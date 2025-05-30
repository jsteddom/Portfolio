//
//  AddPurchaseView.swift
//  BudgetBuilder
//
//  Created by Mitchie Steddom on 5/10/25.
//
import SwiftUI
import SwiftData

struct AddPurchaseView: View {
    // Swift data variables
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Query private var user: [UserInfo]
    // Get model variable
    @ObservedObject var bModel = BudgetModel()
    // State variables for purchse details
    @State var purchaseName: String = ""
    @State var purchaseAmount: String = ""
    @State var purchaseDate: Date = Date()
    @State var purchaseCategory: [String] = ["Food", "Entertainment", "Clothing", "Investment", "Micro-transactions", "Education", "Miscellaneous", "Refund/Return", "Balance Adjustment"]
    @State var selectedCategory: String = ""
    @State var purchaseDescription: String = ""
    // Colors
    var balanceColor: Color = Color(UIColor(red: 0x06/255, green: 0xAE/255, blue: 0x67/255, alpha: 1))
    var purchaseColor: Color = Color(UIColor(red: 0x1F/255, green: 0x22/255, blue: 0x27/255, alpha: 1))
    // Navigation variable
    @State private var navigateToNext = false
    // Response message
    @State private var responseMessage: String = ""
    @State private var responseColor: Color = Color(UIColor(red: 0xE6/255, green: 0xE6/255, blue: 0xE5/255, alpha: 1))

    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor(red: 0x12/255, green: 0x13/255, blue: 0x16/255, alpha: 1))
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Form {
                        Section("Purchase Details") {
                            TextField("Purchase Title", text: $purchaseName)
                            TextField("Purchase Amount", text: $purchaseAmount)
                            DatePicker("Purchase date", selection: $purchaseDate, displayedComponents: .date)
                            Picker("Category", selection: $selectedCategory){
                                ForEach(purchaseCategory, id: \.self){ option in
                                    Text(option)
                                }
                            }
                            
                        }
                        .listRowBackground(Color(UIColor(red: 0x1F/255, green: 0x22/255, blue: 0x27/255, alpha: 1)))
                        .foregroundStyle(Color(UIColor(red: 0xE6/255, green: 0xE6/255, blue: 0xE5/255, alpha: 1)))
                        .font(.system(size: 22))
                        Section("Justification"){
                            TextEditor(text: $purchaseDescription)
                                .frame(height: 150) // Set your preferred height
                                .padding(2)
                                .cornerRadius(8)
                                .font(.system(size: 14))
                        }
                        .listRowBackground(Color(UIColor(red: 0x1F/255, green: 0x22/255, blue: 0x27/255, alpha: 1)))
                        .foregroundStyle(Color(UIColor(red: 0xE6/255, green: 0xE6/255, blue: 0xE5/255, alpha: 1)))
                        .font(.system(size: 22))
                        Button(action: {
                            // Do something
                            if purchaseName != "" && purchaseDescription != "" {
                                if let doubleValue = Double(purchaseAmount) {
                                    if selectedCategory == "Refund/Return" {
                                        let doubleValue = -doubleValue
                                    }
                                    
                                    let newPurchase = bModel.addPurchase(name: purchaseName, category: selectedCategory, date: purchaseDate, cost: doubleValue, justification: purchaseDescription)
                                    
                                    user.first?.purchases.append(newPurchase)
                                    do {
                                        try modelContext.save()
                                        print("Data saved!")
                                        responseMessage = "Successfully added purchase!"
                                        responseColor = Color(UIColor(red: 0xE6/255, green: 0xE6/255, blue: 0xE5/255, alpha: 1))
                                        purchaseName = ""
                                        purchaseAmount = ""
                                        purchaseDescription = ""
                                    } catch {
                                        print("Error saving context: \(error)")
                                    }
                                }
                                else {
                                    print("Invalid amount input.")
                                    responseMessage = "Invalid amount input"
                                    responseColor = Color.red
                                }
                            }
                            else {
                                print("Empty name or description.")
                                responseMessage = "Empty name or description"
                                responseColor = Color.red
                            }
                        }) {
                            
                            ZStack {
                                Rectangle()
                                    .fill(balanceColor)
                                    .frame(width: 350, height: 60)
                                    .cornerRadius(16)
                                Text("Submit")
                                            //.foregroundColor(.white)
                                            .bold()
                            }
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(Color(UIColor(red: 0x12/255, green: 0x13/255, blue: 0x16/255, alpha: 1)))
                        
                            
                        
                    }
                    .scrollContentBackground(.hidden)
                    Text(responseMessage)
                        .padding(.bottom, 60)
                        .font(.system(size: 14))
                        .foregroundStyle(responseColor)
                      
                    
                    
                }
            }
        }

    }
}

#Preview {
    AddPurchaseView()
}
