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
import SwiftData

enum SampleData {
    static let shops = ["Bean There", "Daily Grind", "Roast & Co", "The Steam Room", "Cup & Saucer", "Northern Lights"]

    static func makeVisits() -> [Visit] {
        let drinks: [(String, DrinkType)] = [
            ("Flat white", .espresso), ("Latte", .espresso), ("Cortado", .espresso),
            ("V60 pour over", .filter), ("Batch brew", .filter),
            ("Earl Grey", .tea), ("Matcha latte", .tea),
            ("Nitro cold brew", .coldBrew), ("Hot chocolate", .other)
        ]
        let notes = ["", "Great beans", "Too busy", "Lovely staff", "Would go back", ""]
        return (0..<25).map { i in
            let drink = drinks[(i * 4) % drinks.count]
            return Visit(
                shopName: shops[(i * 5 + i / 3) % shops.count],
                drink: drink.0,
                type: drink.1,
                rating: 2 + (i * 7) % 4,
                notes: notes[i % notes.count],
                date: Calendar.current.date(byAdding: .day, value: -i * 3, to: .now) ?? .now
            )
        }
    }

    static func insert(into context: ModelContext) {
        makeVisits().forEach { context.insert($0) }
        try? context.save()
    }

    static func insertIfEmpty(into context: ModelContext) {
        let count = (try? context.fetchCount(FetchDescriptor<Visit>())) ?? 0
        if count == 0 { insert(into: context) }
    }
}
