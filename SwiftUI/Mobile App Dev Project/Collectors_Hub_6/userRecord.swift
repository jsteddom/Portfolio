//
//  userRecord.swift
//  Collector's_Hub_5
//
//  Created by Jonathan Steddom on 11/29/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
// Record of users
class userRecord: Identifiable {
    var id: UUID
    @Attribute var name: String
    @Attribute var password: String
    @Attribute var items: [itemRecord] = []
    init(name: String, password: String) {
        self.id = UUID()
        self.name = name
        self.password = password
    }
}

// Record of items per user
@Model
class itemRecord: Identifiable {
    var id = UUID()
    @Attribute var name: String
    @Attribute var itemInfo: String
    @Attribute var price: String
    @Attribute var date: Date
    @Attribute var image: Data?
    @Attribute var location: String
    @Attribute var type: String
    
    init(name: String, itemInfo: String, price: String, date: Date, image: Data?, location: String, type: String) {
        self.name = name
        self.itemInfo = itemInfo
        self.price = price
        self.date = date
        self.image = image
        self.location = location
        self.type = type
    }
}
// Struct for Google search repsonse
struct GoogleSearchResponse: Codable {
    struct Item: Codable, Identifiable {
        let id = UUID()
        let title: String
        let link: String
        let image: Image
    }
    
    struct Image: Codable {
        let thumbnailLink: String
        let contextLink: String
        var imageData: Data?
    }
    
    let items: [Item]
}
