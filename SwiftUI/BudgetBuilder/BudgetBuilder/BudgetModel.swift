//
//  BudgetModel.swift
//  BudgetBuilder
//
//  Created by Mitchie Steddom on 5/9/25.
//

import Foundation
import SwiftData

class BudgetModel: ObservableObject {
    //@Published var user: [UserInfo] = []
    //@Published var budget: [PurchaseRecord] = []
    //@Published var expenses: [ExpenseRecord] = []
    // Add a new user
    func addPurchase(name: String, category: String, date: Date, cost: Double, justification: String) -> PurchaseRecord {
        let newPurchase = PurchaseRecord(name: name, category: category, date: date, cost: cost, justification: justification)
        return newPurchase
    }
    
    func addExpense(name: String, category: String, cost: Double, date: Date, justification: String) -> ExpenseRecord {
        let newExpense = ExpenseRecord(name: name, category: category, date: date, cost: cost, justification: justification)
        return newExpense
    }
    
    
}
