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
    @Query(sectionBy: \Visit.shopName) private var visits: SectionedResults<Visit,String>
    @State private var editing: Visit?

    init(searchText: String, allowedTypes: [DrinkType], minRating: Int) {
        var predicates: [Predicate<Visit>] = []
        if !searchText.isEmpty {
            predicates.append(#Predicate<Visit> {
                $0.shopName.localizedStandardContains(searchText) ||
                $0.drink.localizedStandardContains(searchText)
            })
        }
        if allowedTypes.count < DrinkType.allCases.count {
            predicates.append(#Predicate<Visit> {
                allowedTypes.contains($0.type)
            })
        }
        if minRating > 0 {
            predicates.append(#Predicate<Visit> {
                $0.rating >= minRating
            })
        }
        _visits = Query(
            filter: Predicate<Visit>(all: predicates),
            sort: [SortDescriptor(\.shopName), SortDescriptor(\.date, order: .reverse)],
            sectionBy: \.shopName
        )
    }

    var body: some View {
        List {
            Section {
                StatsHeader(visits: visits.flatMap({Array($0)}))
            }
            ForEach(_visits.sections) { section in
                Section {
                    ForEach(section) { visit in
                        Button {
                                editing = visit
                        }label: {
                            VisitRow(visit: visit)
                                .contentShape(.rect)
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete { delete(from: section, at: $0)}
                } header: {
                    Text(section.title)
                        .font(.title).bold()
                }
            }
           
        }
        .overlay {
            if visits.isEmpty {
                ContentUnavailableView.search
            }
        }
        .sheet(item: $editing) { VisitForm(visit: $0) }
    }

    private func delete(from section: ResultsSection<Visit,String>, at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(section[index])
        }
    }
}

#Preview(traits: .sampleData) {
    NavigationStack {
        VisitList(searchText: "", allowedTypes: DrinkType.allCases, minRating: 0)
    }
}
