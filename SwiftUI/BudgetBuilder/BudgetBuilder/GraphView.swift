//
//  GraphView.swift
//  BudgetBuilder
//
//  Created by Mitchie Steddom on 6/1/25.
//

import SwiftUI
import SwiftData
import Charts

struct GraphView: View {
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
    // Chart stuff
    var categoryTotals: [CategoryCost] {
        calculateCategoryTotals(from: currentUser?.purchases ?? [PurchaseRecord](), for: chartDate)
        }
    // Select Date
    @State var chartDate: Date = {
        let calendar = Calendar.current
        let now = Date()
        return calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
    }()

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor(red: 0x12/255, green: 0x13/255, blue: 0x16/255, alpha: 1))
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    DatePicker(
                        "Select Month",
                        selection: $chartDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.compact)
                    /*
                    Button(action: {
                        let _ = print("Total items:\(categoryTotals.count)")
                        ForEach(categoryTotals) { item in
                            let _ = print(item.totalCost)
                            
                        }
                    }, label: {
                        Text("Test")
                    }
                    )
                     */
                    
                    Chart {
                            ForEach(categoryTotals) { item in
                                SectorMark(
                                    angle: .value("Total Cost", item.totalCost),
                                    //innerRadius: .ratio(0.5),
                                    angularInset: 1
                                )
                                .foregroundStyle(by: .value("Category", item.category))
                            }
                        }
                        .frame(height: 300)
                        .chartLegend(.visible)
                        .padding()
                    
                }
                
            }
        }
        .navigationBarBackButtonHidden(true)
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
    struct CategoryCost: Identifiable {
        let id = UUID()
        let category: String
        let totalCost: Double
    }
    
    func calculateCategoryTotals(
        from records: [PurchaseRecord],
        for date: Date
    ) -> [CategoryCost] {
        let calendar = Calendar.current
        let targetComponents = calendar.dateComponents([.year, .month], from: date)
        let filteredRecords = records.filter { record in
            let components = calendar.dateComponents([.year, .month], from: record.date)
            return components.year == targetComponents.year && components.month == targetComponents.month
        }
        
        let grouped = Dictionary(grouping: filteredRecords, by: { $0.category })
        
        
        return grouped.map { (category, records) in
            CategoryCost(category: category, totalCost: records.reduce(0) { $0 + $1.cost })
        }
    }

}

#Preview {
    GraphView()
}
