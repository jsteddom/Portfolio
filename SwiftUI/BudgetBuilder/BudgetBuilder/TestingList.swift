//
//  TestingList.swift
//  BudgetBuilder
//
//  Created by Mitchie Steddom on 5/17/25.
//

import SwiftUI

import SwiftUI

struct DynamicListView: View {
    @State private var items: [String] = ["Apples", "Bananas"]
    @State private var newItem: String = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Add new item", text: $newItem)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        guard !newItem.isEmpty else { return }
                        items.append(newItem)
                        newItem = ""
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
                .padding()

                List {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationTitle("Shopping List")
            .toolbar {
                EditButton()
            }
        }
    }

    func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}
#Preview {
    DynamicListView()
}
