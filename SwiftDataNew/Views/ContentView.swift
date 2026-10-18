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

struct ContentView: View {
    @State private var searchText = ""
    @State private var showingAdd = false
    @State private var allowedTypes = DrinkType.allCases
    @State private var minRating = 0

    var body: some View {
        NavigationStack {
            VisitList(searchText: searchText, allowedTypes: allowedTypes, minRating: minRating)
                .navigationTitle("CafeLog")
                .searchable(text: $searchText, prompt: "Shop name")
                .toolbar {
                    Menu("Filter", systemImage: "line.3.horizontal.decrease") {
                        ForEach(DrinkType.allCases) { type in
                            Toggle(type.title, isOn: binding(for: type))
                        }
                        Stepper("Minimum rating: \(minRating)", value: $minRating, in: 0...5)
                    }
                    .menuActionDismissBehavior(.disabled)
                    Button("Add", systemImage: "plus") { showingAdd = true }
                }
                .sheet(isPresented: $showingAdd) { VisitForm(visit: nil) }
        }
    }
    
    private func binding(for type: DrinkType) -> Binding<Bool> {
        Binding {
            allowedTypes.contains(type)
        } set: { isOn in
            if isOn {
                allowedTypes.append(type)
            } else {
                allowedTypes.removeAll(where: {$0 == type })
            }
        }

    }
}

#Preview(traits: .sampleData) {
    ContentView()
}
