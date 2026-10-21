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


import SwiftUI
import SwiftData

@Observable
final class StatsStore {
    private let observer: ResultsObserver<Visit, Never>
    @ObservationIgnored private var token: ObservationTracking.Token?
    
    private(set) var totalVisits = 0
    private(set) var averageRating = 0.0
    private(set) var topShop = "None"
    
    init(modelContext: ModelContext) throws {
        observer = try ResultsObserver<Visit, Never>(modelContext: modelContext)
        token = withContinuousObservation(options: [.didSet], apply: { [weak self] _ in
            guard let self else { return }
            self.update(with: Array(self.observer.results))
        })
    }
    
    private func update(with visits: [Visit]) {
        totalVisits = visits.count
        averageRating = visits.isEmpty ? 0 : Double(visits.map(\.rating).reduce(0, +)) / Double(visits.count)
        topShop = Dictionary(grouping: visits, by: \.shopName)
            .max { $0.value.count < $1.value.count}?.key ?? "None"
    }
}
