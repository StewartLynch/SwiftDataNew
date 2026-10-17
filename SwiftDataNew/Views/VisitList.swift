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

struct VisitList: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var visits: [Visit]
    @State private var editing: Visit?

    init(searchText: String) {
        let predicate = #Predicate<Visit> { visit in
            searchText.isEmpty || visit.shopName.localizedStandardContains(searchText)
        }
        _visits = Query(filter: predicate, sort: \.date, order: .reverse)
    }

    var body: some View {
        List {
            Section {
                StatsHeader(visits: visits)
            }
            Section {
                ForEach(visits) { visit in
                    Button { editing = visit } label: {
                        VisitRow(visit: visit)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                .onDelete(perform: delete)
            }
        }
        .overlay {
            if visits.isEmpty {
                ContentUnavailableView.search
            }
        }
        .sheet(item: $editing) { VisitForm(visit: $0) }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(visits[index])
        }
    }
}

#Preview(traits: .sampleData) {
    NavigationStack {
        VisitList(searchText: "")
    }
}
