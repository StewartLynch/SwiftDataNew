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

@Model
final class Visit {
    var shopName: String
    var drink: String
    var type: DrinkType
    var rating: Int
    var notes: String
    var date: Date


    init(shopName: String, drink: String, type: DrinkType, rating: Int, notes: String = "", date: Date = .now) {
        self.shopName = shopName
        self.drink = drink
        self.type = type
        self.rating = rating
        self.notes = notes
        self.date = date
    }
}
