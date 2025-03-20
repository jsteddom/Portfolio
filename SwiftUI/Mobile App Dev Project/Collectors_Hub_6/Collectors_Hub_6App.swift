//
//  Collectors_Hub_6App.swift
//  Collectors_Hub_6
//
//  Created by Mitchie Steddom on 11/30/24.
//

import SwiftUI

@main
struct Collectors_Hub_6App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: userRecord.self)
    }
}
