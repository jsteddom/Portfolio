//
//  ViewPurchaseView.swift
//  BudgetBuilder
//
//  Created by Mitchie Steddom on 5/13/25.
//
import SwiftUI
import SwiftData

struct ViewPurchaseView: View {
    // Swift data variables
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Query private var user: [UserInfo]
    // Get model variable
    @ObservedObject var bModel = BudgetModel()
    // User
    var currentUser: UserInfo? {
        user.first
    }
    // Colors
    var purchaseColor: Color = Color(UIColor(red: 0x1F/255, green: 0x22/255, blue: 0x27/255, alpha: 1))
    var balanceColor: Color = Color(UIColor(red: 0x06/255, green: 0xAE/255, blue: 0x67/255, alpha: 1))
    var offWhite: Color = Color(UIColor(red: 0xE6/255, green: 0xE6/255, blue: 0xE5/255, alpha: 1))
    // Buttons
    @State var toDeleteView: Bool = false
    // Deletion record
    @State var toDeletePurchase: PurchaseRecord? = nil
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor(red: 0x12/255, green: 0x13/255, blue: 0x16/255, alpha: 1))
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack {
                        let grouped = Dictionary(grouping: currentUser?.purchases ?? []) { purchase in
                            let date = purchase.date
                            let formatter = DateFormatter()
                            formatter.dateFormat = "MMMM yyyy" // Example: "April 2025"
                            return formatter.string(from: date)
                        }

                        let sortedKeys = grouped.keys.sorted(by: >) // Newest month first
                        
                        ForEach(sortedKeys, id: \.self) { key in
                            Section(header: HStack {
                                Text(key)
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.leading, 20)
                                    Spacer() // Pushes text to the left
                            }) {
                                ForEach(grouped[key]!) { purchase in
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
                                                // Delete button
                                                Button(action: {
                                                    toDeletePurchase = purchase
                                                    toDeleteView = true
                                                }, label: {
                                                    Image(systemName: "trash")
                                                }
                                                )
                                                .padding(.leading, 30)
                                                .padding(.trailing, 16)
                                            }
                                        )
                                }
                            }
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .alert("Delete Item", isPresented: $toDeleteView, actions: {
                        // Cancel button to exit view without deleting
                        Button("Cancel", role: .cancel, action: {
                            toDeleteView = false
                        })
                        // Call delete function and delete movie record based on movie name given
                        Button("Delete", action: {
                            if let purchase = toDeletePurchase {
                                modelContext.delete(purchase)
                                do {
                                    try modelContext.save()
                                    print("Purchase deleted and data saved.")
                                } catch {
                                    print("Error saving context after delete: \(error)")
                                }
                                toDeletePurchase = nil
                            }

                            
                        })
                    }, message: {
                        Text("Enter name of item you would like to delete")
                    })
                }
                
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
    
    func getImage(category: String) -> String {
        if category == "Food" {
            return "fork.knife.circle"
        }
        else if category == "Clothing" {
            return "tshirt.circle"
        }
        else if category == "Entertainment" {
            return "tv.circle"
        }
        else if category == "Investment" {
            return "dollarsign.circle"
        }
        else if category == "Micro-transactions" {
            return "gamecontroller.circle"
        }
        else if category == "Education" {
            return "books.vertical.circle"
        }
        else if category == "Miscellaneous" {
            return "centsign.circle"
        }
        return "dollarsign.circle"
    }
}

#Preview {
    ViewPurchaseView()
}

/*
 // Delete button
 Button(action: {
     toDeletePurchase = purchase
     toDeleteView = true
 }, label: {
     Image(systemName: "trash")
 }
 )
 */
