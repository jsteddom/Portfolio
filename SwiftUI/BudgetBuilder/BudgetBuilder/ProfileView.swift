//
//  ProfileView.swift
//  BudgetBuilder
//
//  Created by Mitchie Steddom on 5/13/25.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
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
    var backgroundC = Color(red: 167/255, green: 169/255, blue: 172/255)
    var balanceColor: Color = Color(UIColor(red: 0x06/255, green: 0xAE/255, blue: 0x67/255, alpha: 1))
    var purchaseColor: Color = Color(UIColor(red: 0x1F/255, green: 0x22/255, blue: 0x27/255, alpha: 1))
    var offWhite: Color = Color(UIColor(red: 0xE6/255, green: 0xE6/255, blue: 0xE5/255, alpha: 1))
    // Alert for edit
    @State var editGoals: Bool = false
    // Edit variables
    @State var expenseBudget: String = ""
    @State var utilitiesBudget: String = ""
    @State var nonEssentialsBudget: String = ""
    @State var incomeGoal: String = ""
    @State var savingsGoal: String = ""
    // Error message
    @State var errorMessage: String = ""
    // Edit balance alert
    @State var editBalance: Bool = false
    // Balance variable
    @State var balance: String = ""
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor(red: 0x12/255, green: 0x13/255, blue: 0x16/255, alpha: 1))
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Your Information")
                        .font(.title)
                        .foregroundStyle(balanceColor)
                        .padding(.top, 20)
                        .padding(.bottom, 60)
                    HStack {
                        Text("Your balance: ")
                            .foregroundStyle(offWhite)
                        Text(String(format: "$%.2f", currentUser?.accValue ?? 0.0))
                            .foregroundStyle(offWhite)
                        Button (action: {
                            editBalance.toggle()
                        }, label: {
                            Image(systemName: "pencil")
                                .foregroundColor(balanceColor)
                        })
                    }
                    .font(.system(size: 28, weight: .bold))
                    Section("Monthly Finance Goals") {
                        List {
                            HStack {
                                Text("Expense Budget: ")
                                    .font(.system(size: 18))
                                Spacer()
                                Text(String(format: "$%.2f", currentUser?.expenseBudget ?? 0.0))
                                    .foregroundStyle(offWhite)
                            }
                            .listRowBackground(purchaseColor)
                            HStack {
                                Text("Utilities Budget: ")
                                    .font(.system(size: 18))
                                Spacer()
                                Text(String(format: "$%.2f", currentUser?.utilityBudget ?? 0.0))
                                    .foregroundStyle(offWhite)
                            }
                            .listRowBackground(purchaseColor)
                            HStack {
                                Text("Non-Essentials Budget:")
                                    .font(.system(size: 18))
                                Spacer()
                                Text(String(format: "$%.2f", currentUser?.nonEssentialBudget ?? 0.0))
                                    .foregroundStyle(offWhite)
                            }
                            .listRowBackground(purchaseColor)
                            HStack {
                                Text("Income Goal: ")
                                    .font(.system(size: 18))
                                Spacer()
                                Text(String(format: "$%.2f", currentUser?.incomeGoal ?? 0.0))
                                    .foregroundStyle(offWhite)
                            }
                            .listRowBackground(purchaseColor)
                            HStack {
                                Text("Savings Goal: ")
                                    .font(.system(size: 18))
                                Spacer()
                                Text(String(format: "$%.2f", currentUser?.savingsGoal ?? 0.0))
                                    .foregroundStyle(offWhite)
                            }
                            .listRowBackground(purchaseColor)
                            
                            
                        }
                        .scrollContentBackground(.hidden)
                        
                    }
                    .foregroundStyle(Color.white)
                    .padding(.top, 20)
                    .font(.system(size: 22, weight: .bold))
                    
                    Button(action: {
                        // Do something
                        editGoals.toggle()
                    }) {
                        ZStack {
                            Rectangle()
                                .fill(balanceColor)
                                .frame(width: 350, height: 60)
                                .cornerRadius(16)
                            Text("Edit Goals")
                                        //.foregroundColor(.white)
                                        .bold()
                        }
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color(UIColor(red: 0x12/255, green: 0x13/255, blue: 0x16/255, alpha: 1)))
                    
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
            }
            .alert("Edit goals", isPresented: $editGoals, actions: {
                
                TextField("Expense Budget: ", text: $expenseBudget)
                    .keyboardType(.decimalPad)
                TextField("Utilities Budget: ", text: $utilitiesBudget)
                    .keyboardType(.decimalPad)
                TextField("Non-Essentials Budget: ", text: $nonEssentialsBudget)
                    .keyboardType(.decimalPad)
                TextField("Income Goal: ", text: $incomeGoal)
                    .keyboardType(.decimalPad)
                TextField("Savings Goal: ", text: $savingsGoal)
                    .keyboardType(.decimalPad)
                
                Button("Cancel", role: .cancel, action: {
                    editGoals = false
                })
                Button("Change", action: {
                    if let ExpenseBudget = Double(expenseBudget), let UtilitiesBudget = Double(utilitiesBudget), let NonEssentialsBudget = Double(nonEssentialsBudget), let IncomeGoal = Double(incomeGoal), let SavingsGoal = Double(savingsGoal) {
                        currentUser?.expenseBudget = ExpenseBudget
                        currentUser?.utilityBudget = UtilitiesBudget
                        currentUser?.nonEssentialBudget = NonEssentialsBudget
                        currentUser?.incomeGoal = IncomeGoal
                        currentUser?.savingsGoal = SavingsGoal
                        errorMessage = ""
                        
                        expenseBudget = ""
                        utilitiesBudget = ""
                        nonEssentialsBudget = ""
                        incomeGoal = ""
                        savingsGoal = ""
                        do {
                            try modelContext.save()
                            print("Data saved!")
                        } catch {
                            print("Error saving context: \(error)")
                        }
                        dismiss()
                    }
                    else {
                        errorMessage = "All values must be numbers"
                    }
                    
                })
            }, message: {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            )
            .alert("Edit Balance", isPresented: $editBalance, actions: {
                TextField("New Balance: ", text: $balance)
                Button("Cancel", role: .cancel, action: {
                    editBalance = false
                })
                Button("Save", action: {
                    if let newBalance = Double(balance) {
                        currentUser?.accValue = newBalance
                        errorMessage = ""
                        
                        do {
                            try modelContext.save()
                            print("Data saved!")
                        } catch {
                            print("Error saving context: \(error)")
                        }
                        dismiss()
                    }
                    else {
                        
                    }
                })

            })
        }
        .navigationBarBackButtonHidden(true)
        .onAppear()
    }
    
}

#Preview {
    ProfileView()
}
