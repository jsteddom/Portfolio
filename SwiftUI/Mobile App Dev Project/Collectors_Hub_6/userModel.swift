//
//  userModel.swift
//  Collector's_Hub_5
//
//  Created by Jonathan Steddom on 11/29/24.
//

import Foundation
import SwiftData

class userModel: ObservableObject {
    @Published var users: [userRecord] = []
    var defaultUser = userRecord(name: "M", password: "password")
    // Add a new user
    func addUser(name: String, password: String) -> userRecord{
        let newUser = userRecord(name: name, password: password)
        return newUser
    }
    // Add an item for user signed in
    func addItem (name: String, itemInfo: String, price: String, date: Date, image: Data, location: String, type: String) -> itemRecord {
        let newItem = itemRecord(name: name, itemInfo: itemInfo, price: price, date: date, image: image, location: location, type: type)
        return newItem
    }
    // Verify user credentials for log in
    func verifyUser(name: String, password: String) -> Bool {
        if let user = users.first(where: { $0.name == name && $0.password == password }) {
            //currentUser = user
            return true
        }
        return false
    }
    
}
