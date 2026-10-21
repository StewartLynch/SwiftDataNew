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

struct StatsHeader: View {
    @Environment(StatsStore.self) private var stats
   

    var body: some View {
        HStack {
            stat("Visits", "\(stats.totalVisits)")
            Divider()
            stat("Average", stats.averageRating.formatted(.number.precision(.fractionLength(1))))
            Divider()
            stat("Top shop", stats.topShop)
        }
        .frame(height: 56)
        .padding(.horizontal)
    }

    private func stat(_ title: String, _ value: String) -> some View {
        VStack {
            Text(value).font(.headline).lineLimit(1).minimumScaleFactor(0.7)
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    StatsHeader()
}
