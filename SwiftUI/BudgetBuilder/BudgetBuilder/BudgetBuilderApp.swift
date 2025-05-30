//
//  BudgetBuilderApp.swift
//  BudgetBuilder
//
//  Created by Mitchie Steddom on 5/9/25.
//

import SwiftUI

@main
struct BudgetBuilderApp: App {
    init() {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0x12/255, green: 0x13/255, blue: 0x16/255, alpha: 1)
            
            UITabBar.appearance().standardAppearance = appearance
            
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: UserInfo.self)
    }
}
