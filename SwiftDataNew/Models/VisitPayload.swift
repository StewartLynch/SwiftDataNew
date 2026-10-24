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
import MapKit

struct VisitPayload: Codable {
    enum Operation: String, Codable {
        case insert, update, delete
    }
    let operation: Operation
    let id: UUID
    var shopName: String?
    var drink: String?
    var type: DrinkType?
    var rating: Int?
    var notes: String?
    var date: Date?
    var mapItemIdentifier: MKMapItem.Identifier?
}

extension VisitPayload {
    init(inserted visit: Visit) {
        self.init(
            operation: .insert,
            id: visit.uuid,
            shopName: visit.shopName,
            drink: visit.drink,
            type: visit.type,
            rating: visit.rating,
            notes: visit.notes,
            date: visit.date,
            mapItemIdentifier: visit.mapItemIdentifier
        )
    }
    
    init(deleted id: UUID) {
        self.init(operation: .delete, id: id)
    }
    
    init(updated visit: Visit, fields: [PartialKeyPath<Visit>]) {
        self.init(operation: .update, id: visit.uuid)
        for field in fields {
            switch field {
            case \Visit.shopName: shopName = visit.shopName
            case \Visit.drink: drink = visit.drink
            case \Visit.type: type = visit.type
            case \Visit.rating: rating = visit.rating
            case \Visit.notes: notes = visit.notes
            case \Visit.date: date = visit.date
            case \Visit.mapItemIdentifier: mapItemIdentifier = visit.mapItemIdentifier
            default: break
            
            }
        }
    }
}
