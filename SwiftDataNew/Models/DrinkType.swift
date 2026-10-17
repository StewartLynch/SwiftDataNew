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


import Foundation

enum DrinkType: String, Codable, CaseIterable, Identifiable {
    case espresso, filter, tea, coldBrew, other

    var id: String { rawValue }

    var title: String {
        switch self {
        case .espresso: "Espresso"
        case .filter: "Filter"
        case .tea: "Tea"
        case .coldBrew: "Cold Brew"
        case .other: "Other"
        }
    }
}
