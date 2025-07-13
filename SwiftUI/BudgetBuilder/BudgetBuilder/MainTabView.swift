//
//  MainTabView.swift
//  BudgetBuilder
//
//  Created by Mitchie Steddom on 5/13/25.
//
import SwiftUI
import SwiftData

struct MainTabView: View {
    var body: some View {
        ZStack {
            Color(UIColor(red: 0x12/255, green: 0x13/255, blue: 0x16/255, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            
            TabView {
                
                ContentView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                AddPurchaseView()
                    .tabItem {
                        Label("Add", systemImage: "plus.app")
                    }
                
                ViewPurchaseView()
                    .tabItem {
                        Label("Purchases", systemImage: "note.text")
                    }
                GraphView()
                    .tabItem {
                        Label("Numbers", systemImage: "chart.pie.fill")
                    }
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.square")
                    }
                 
            }
        }
        
    }
}
