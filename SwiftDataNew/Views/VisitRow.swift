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

struct VisitRow: View {
    let visit: Visit

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(visit.shopName).font(.headline)
                Spacer()
                Text(String(repeating: "★", count: visit.rating))
                    .foregroundStyle(.orange)
            }
            Text("\(visit.drink) · \(visit.type.title)")
                .font(.subheadline)
            Text(visit.date.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    VisitRow(visit: SampleData.makeVisits()[0])
        .padding()
}
