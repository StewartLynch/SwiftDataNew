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

import MapKit
import SwiftUI
import SwiftData

struct VisitForm: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let visit: Visit?

    @State private var shopName = ""
    @State private var drink = ""
    @State private var type = DrinkType.espresso
    @State private var rating = 3
    @State private var notes = ""
    @State private var date = Date.now
    @State private var mapItemIdentifier: MKMapItem.Identifier?
    @State private var showingSearch = false
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Shop name", text: $shopName)
                TextField("Drink", text: $drink)
                Picker("Type", selection: $type) {
                    ForEach(DrinkType.allCases) { Text($0.title).tag($0) }
                }
                Stepper("Rating: \(rating)", value: $rating, in: 1...5)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Notes", text: $notes, axis: .vertical)
                Section("Cafe") {
                    Button("Find Cafe", systemImage: "magnifyingglass") {
                        showingSearch = true
                    }
                    if let mapItemIdentifier {
                        Button("Open in Maps", systemImage: "map") {
                            Task {
                                await openInMaps(mapItemIdentifier)
                            }
                        }
                    }
                }
            }
            .navigationTitle(visit == nil ? "New Visit" : "Edit Visit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .disabled(shopName.isEmpty || drink.isEmpty)
                }
            }
            .onAppear(perform: load)
            .sheet(isPresented: $showingSearch) {
                CafeSearch { item in
                    if shopName.isEmpty {
                        shopName = item.name ?? ""
                    }
                    mapItemIdentifier = item.identifier
                }
            }
        }
    }

    private func load() {
        guard let visit else { return }
        shopName = visit.shopName
        drink = visit.drink
        type = visit.type
        rating = visit.rating
        notes = visit.notes
        date = visit.date
        mapItemIdentifier = visit.mapItemIdentifier
    }

    private func save() {
        if let visit {
            visit.shopName = shopName
            visit.drink = drink
            visit.type = type
            visit.rating = rating
            visit.notes = notes
            visit.date = date
            visit.mapItemIdentifier = mapItemIdentifier
        } else {
            modelContext.insert(
                Visit(
                    shopName: shopName,
                    drink: drink,
                    type: type,
                    rating: rating,
                    notes: notes,
                    date: date,
                    mapItemIdentifier: mapItemIdentifier
                )
            )
        }
        dismiss()
    }
    
    private func openInMaps( _ identifier: MKMapItem.Identifier) async {
        let request = MKMapItemRequest(mapItemIdentifier: identifier)
        if let item = try? await request.mapItem {
            item.openInMaps()
        }
        
    }
}

#Preview(traits: .sampleData) {
    VisitForm(visit: nil)
}
