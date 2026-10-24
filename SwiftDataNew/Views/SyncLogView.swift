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

struct SyncLogView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SyncEngine.self) private var engine

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button("Simulate Server Change") { engine.simulateServerChange()
                    }
                }
                if engine.log.isEmpty {
                    ContentUnavailableView("No changes yet", systemImage: "arrow.triangle.2.circlepath")
                }
                ForEach(Array(engine.log.enumerated().reversed()), id: \.offset) { _, line in
                    Text(line)
                        .font(.system(.caption, design: .monospaced))
                }
            }
            .navigationTitle("Sync Log")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview(traits: .sampleData) {
    SyncLogView()
    
}
