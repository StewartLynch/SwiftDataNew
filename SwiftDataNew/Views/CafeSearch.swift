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
import MapKit

struct CafeSearch: View {
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    @State private var results: [MKMapItem] = []

    let onSelect: (MKMapItem) -> Void
    var body: some View {
        NavigationStack {
            List(results, id: \.self) { item in
                Button {
                    onSelect(item)
                    dismiss()
                } label: {
                    VStack(alignment: .leading) {
                        Text(item.name ?? "Unknown")
                        Text(item.address?.shortAddress ?? "")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Find Cafe")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $query, prompt: "Cafe name or city")
            .onSubmit(of: .search) { Task { await search() } }
            .toolbar {
                Button("Cancel") { dismiss() }
            }
        }
    }

    private func search() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: [.cafe])
        results = (try? await MKLocalSearch(request: request).start().mapItems) ?? []
    }
}

#Preview {
    CafeSearch { _ in }
}
