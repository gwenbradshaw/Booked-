//
//  GroceryDetailView.swift
//  Booked!
//
//  Created by gwen bradshaw on 4/7/26.
//


import SwiftUI

struct GroceryDetailView: View {
    @AppStorage("dairy_list") private var savedDairy: String = ""
    @AppStorage("meat_list") private var savedMeat: String = ""
    @AppStorage("produce_list") private var savedProduce: String = ""
    @AppStorage("snack_list") private var savedSnacks: String = ""
    @AppStorage("dessert_list") private var savedDesserts: String = ""
    @State private var newInputs: [String: String] = [:]
    @State private var checkedItems: Set<String> = []

    var body: some View {
        List {
            grocerySection(title: "Dairy", savedString: $savedDairy)
            grocerySection(title: "Meat", savedString: $savedMeat)
            grocerySection(title: "Produce", savedString: $savedProduce)
            grocerySection(title: "Snacks", savedString: $savedSnacks)
            grocerySection(title: "Desserts", savedString: $savedDesserts)
            
            Button("Clear All", role: .destructive) {
                savedDairy = ""; savedMeat = ""; savedProduce = ""; savedSnacks = ""; savedDesserts = ""
                checkedItems.removeAll()
            }
        }
        .navigationTitle("Groceries")
    }

    @ViewBuilder
    func grocerySection(title: String, savedString: Binding<String>) -> some View {
        Section(title) {
            let items = savedString.wrappedValue.components(separatedBy: ",").filter { !$0.isEmpty }
            ForEach(items, id: \.self) { item in
                HStack {
                    Image(systemName: checkedItems.contains(item) ? "checkmark.circle.fill" : "circle")
                    Text(item).strikethrough(checkedItems.contains(item))
                }
                .onTapGesture {
                    if checkedItems.contains(item) { checkedItems.remove(item) }
                    else { checkedItems.insert(item) }
                }
            }
            TextField("Add to \(title)...", text: Binding(
                get: { newInputs[title] ?? "" },
                set: { newInputs[title] = $0 }
            ))
            .onSubmit {
                if let val = newInputs[title], !val.isEmpty {
                    savedString.wrappedValue += (savedString.wrappedValue.isEmpty ? "" : ",") + val
                    newInputs[title] = ""
                }
            }
        }
    }
}