//
//  ContentView.swift
//  BudgetBuilder
//
//  Created by Mitchie Steddom on 5/9/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var user: [UserInfo]
    var backgroundC = Color(red: 167/255, green: 169/255, blue: 172/255)
    var balanceColor: Color = Color(UIColor(red: 0x06/255, green: 0xAE/255, blue: 0x67/255, alpha: 1))
    var purchaseColor: Color = Color(UIColor(red: 0x1F/255, green: 0x22/255, blue: 0x27/255, alpha: 1))
    var offWhite: Color = Color(UIColor(red: 0xE6/255, green: 0xE6/255, blue: 0xE5/255, alpha: 1))
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor(red: 0x12/255, green: 0x13/255, blue: 0x16/255, alpha: 1))

                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 10) {
                    Rectangle()
                        .fill(balanceColor)
                        .frame(width: 350, height: 120)
                        .cornerRadius(16)
                        .padding(.top, 20)
                        .padding(.bottom, 50)
                    Text("Recent Purchases")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(UIColor(red: 0xE6/255, green: 0xE6/255, blue: 0xE5/255, alpha: 1)))
                        .padding(.bottom, 10)
                    ScrollView {
                        if let user = user.first {
                            ForEach(user.purchases.sorted(by: { $0.date > $1.date }).prefix(10)) { purchase in
                                // Your view here
                                Rectangle()
                                    .fill(purchaseColor)
                                    .frame(width: 350, height: 60)
                                    .cornerRadius(16)
                                    //.padding(.top, 10)
                                    //.padding(.bottom, 10)
                                    .overlay(
                                        HStack {
                                            Image(systemName: getImage(category: purchase.category))
                                                .font(.system(size: 24))
                                                .foregroundStyle(offWhite)
                                                .padding(.leading, 16)
                                                .padding(.trailing, 10)
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(purchase.name)
                                                    .foregroundStyle(offWhite)
                                                Text(formatDate(purchase.date))
                                                    .foregroundStyle(offWhite)
                                                    .font(.caption)
                                                    .font(.system(size: 17))
                                            }
                                            Spacer()
                                            Text(String(format: "$%.2f", purchase.cost))
                                                .foregroundStyle(offWhite)
                                                .padding(.trailing, 16)
                                        }
                                    )
                            }
                        }
                        else {
                            Rectangle()
                                .fill(purchaseColor)
                                .frame(width: 350, height: 60)
                                .cornerRadius(16)
                                .padding(.top, 20)
                                .padding(.bottom, 50)
                                .overlay(
                                    Text("Goon")
                                )
                        }
                    }
                    /*
                    Rectangle()
                        .fill(purchaseColor)
                        .frame(width: 350, height: 60)
                        .cornerRadius(16)
                        .padding(.top, 20)
                        .padding(.bottom, 50)
                      */
                    
                }
                .frame(maxHeight: .infinity, alignment: .top)
                /*
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        HStack {
                            NavigationLink(destination: ContentView()){
                                Image(systemName: "house")
                            }
                            NavigationLink(destination: AddPurchaseView()){
                                Image(systemName:"plus.app")
                            }
                            NavigationLink(destination: ViewPurchaseView()) {
                                Image(systemName: "note.text")
                            }
                            NavigationLink(destination: ProfileView()) {
                                Image(systemName: "person.crop.square")
                            }
                            
                        }
                    }
                }
                */

            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            createFirstUser()
        }
        
    }
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
    
    func createFirstUser() {
        let defaultUser = UserInfo(accValue: 0.00, expenseBudget: 0.00, utilityBudget: 0.00, nonEssentialBudget: 0.00, incomeGoal: 0.00, savingsGoal: 0.00)
        modelContext.insert(defaultUser)
        try? modelContext.save()
    }
    
    func getImage(category: String) -> String {
        if category == "Food" {
            return "fork.knife"
        }
        else if category == "Clothing" {
            return "tshirt"
        }
        else if category == "Entertainment" {
            return "tv"
        }
        else if category == "Investment" {
            return "dollarsign"
        }
        else if category == "Micro-transactions" {
            return "gamecontroller"
        }
        else if category == "Education" {
            return "books.vertical"
        }
        else if category == "Miscellaneous" {
            return "centsign"
        }
        return "dollarsign.circle"
    }
    
}

struct PurchaseCell: View {
    var body: some View {
        Text("PurchaseCell")
    }
}


#Preview {
    ContentView()
}
