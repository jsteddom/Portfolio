//
//  BudgetRecord.swift
//  BudgetBuilder
//
//  Created by Mitchie Steddom on 5/9/25.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class UserInfo: Identifiable {
    @Attribute var accValue: Double
    @Attribute var expenseBudget: Double
    @Attribute var utilityBudget: Double
    @Attribute var nonEssentialBudget: Double
    @Attribute var incomeGoal: Double
    @Attribute var savingsGoal: Double
    @Attribute var expenses: [ExpenseRecord] = []
    @Attribute var purchases: [PurchaseRecord] = []
    @Attribute var income: [IncomeRecord] = []
    init(accValue: Double, expenseBudget: Double, utilityBudget: Double, nonEssentialBudget: Double, incomeGoal: Double, savingsGoal: Double) {
        self.accValue = accValue
        self.expenseBudget = expenseBudget
        self.utilityBudget = utilityBudget
        self.nonEssentialBudget = nonEssentialBudget
        self.incomeGoal = incomeGoal
        self.savingsGoal = savingsGoal
    }
}
@Model
class IncomeRecord: Identifiable {
    var id: UUID
    @Attribute var category: String
    @Attribute var date: Date
    @Attribute var amount: Double
    @Attribute var justification: String
    init(category: String, date: Date, amount: Double, justification: String) {
        self.id = UUID()
        self.category = category
        self.date = date
        self.amount = amount
        self.justification = justification
    }
}

@Model
class ExpenseRecord: Identifiable {
    var id: UUID
    @Attribute var name: String
    @Attribute var category: String
    @Attribute var date: Date
    @Attribute var cost: Double
    @Attribute var justification: String
    init(name: String, category: String, date: Date, cost: Double, justification: String) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.date = date
        self.cost = cost
        self.justification = justification
    }
}

@Model
class PurchaseRecord: Identifiable {
    var id: UUID
    @Attribute var name: String
    @Attribute var category: String
    @Attribute var date: Date
    @Attribute var cost: Double
    @Attribute var justification: String
    init(name: String, category: String, date: Date, cost: Double, justification: String) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.date = date
        self.cost = cost
        self.justification = justification
    }
}
/*
class BudgetHistoy : Identifiable {
    var id: UUID
    @Attribute var accountBalance: Double
    @Attribute var income: Double
    @Attribute var expenses: Double
}
*/
