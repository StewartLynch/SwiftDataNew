//
//----------------------------------------------
// Original project: SwiftDataNew
//
// Follow me on Mastodon: https://iosdev.space/@StewartLynch
// Follow me on Threads: https://www.threads.net/@stewartlynch
// Follow me on Bluesky: https://bsky.app/profile/stewartlynch.bsky.social
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Email: slynch@createchsol.com
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch
//----------------------------------------------
// Copyright © 2026 CreaTECH Solutions (Stewart Lynch). All rights reserved.

import SwiftData
import SwiftUI

@Observable
final class SyncEngine {
    private let container: ModelContainer
    private let observer: HistoryObserver
    private static let tokenKey = "SyncEngine.lastToken"
    @ObservationIgnored private var token: ObservationTracking.Token?
    @ObservationIgnored private var lastToken: DefaultHistoryToken?
    
    private(set) var log: [String] = []
    
    init(container: ModelContainer) throws {
        self.container = container
        observer = try HistoryObserver(authors: [HistoryAuthor.app.rawValue], modelContainer: container)
        token = withContinuousObservation(options: [.didSet], apply: { [weak self] _ in
            _ = self?.observer.eventCounter
            self?.processChanges()
        })
        lastToken = loadToken()
    }
    
    private func visit(for id: PersistentIdentifier, in context: ModelContext) -> Visit? {
        let descriptor = FetchDescriptor<Visit>(predicate: #Predicate{$0.persistentModelID == id})
        return try? context.fetch(descriptor).first
    }
    
    private func upload(_ changes: [VisitPayload]) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .sortedKeys
        for change in changes {
            log.append(String(decoding: try encoder.encode(change), as: UTF8.self))
        }
    }
    
    private func processChanges() {
        let context = ModelContext(container)
        let after = lastToken
        let app = HistoryAuthor.app.rawValue
        
        let predicate = #Predicate<DefaultHistoryTransaction> { transaction in
            transaction.author == app && (after == nil || transaction.token > after!)
        }
        
        var descriptor = HistoryDescriptor(predicate: predicate)
        descriptor.sortBy = [SortDescriptor(\.transactionIdentifier)]
        guard let transactions = try? context.fetchHistory(descriptor),
              let newest = transactions.last?.token else { return }
        var changes: [VisitPayload] = []
        for transaction in transactions {
            for change in transaction.changes {
                switch change {
                case .insert(let insert):
                    if let visit = visit(for: insert.changedPersistentIdentifier, in: context) {
                        changes.append(VisitPayload(inserted: visit))
                    }
                case .update(let update):
                    if let visit = visit(for: update.changedPersistentIdentifier, in:  context),
                       let update = update as? DefaultHistoryUpdate<Visit> {
                        changes.append(VisitPayload(updated: visit, fields: update.updatedAttributes))
                    }
                case .delete(let delete):
                    if let id = (delete as? DefaultHistoryDelete<Visit>)?.tombstone[\.uuid] as? UUID {
                        changes.append(VisitPayload(deleted: id))
                    }
                @unknown default:
                    break
                }

            }
        }
        do {
            try upload(changes)
            lastToken = newest
            saveToken(newest)
        } catch {
            return
        }
    }
    
    func simulateServerChange() {
        let context = ModelContext(container)
        context.author = HistoryAuthor.server.rawValue
        context.insert(
            Visit(
                shopName: "Server Cafe",
                drink: "Flat White",
                type: .espresso,
                rating: 5
            )
        )
        try? context.save()
    }
    
    private func loadToken() -> DefaultHistoryToken? {
        guard let data = UserDefaults.standard.data(forKey: Self.tokenKey) else { return nil }
        return try? JSONDecoder().decode(DefaultHistoryToken.self, from: data)
    }
    
    private func saveToken(_ historyToken: DefaultHistoryToken) {
        UserDefaults.standard.set(try? JSONEncoder().encode(historyToken), forKey: Self.tokenKey)
    }
}
