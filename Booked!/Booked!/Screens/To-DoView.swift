//
//  To-DoView.swift
//  Booked!
//
//  Created by gwen bradshaw on 2/26/26.
//

import SwiftUI

struct To_DoView: View {
    @State private var categories = ["Groceries", "Gym"]

    var body: some View {
    
        List(categories, id: \.self) { category in
            if category == "Gym" {
                //  the tappable link for the Gym
                NavigationLink(destination: GymView()) {
                    Label("Gym", systemImage: "figure.run")
                }
            } else if category == "Groceries" {
                // This creates the tappable link for Groceries
                NavigationLink(destination: GroceryDetailView()) {
                    Label("Groceries", systemImage: "cart")
                }
            }
        }
        .navigationTitle("To-do's")
    }
}

struct GroceryDetailView: View {
 //premade lists
    @AppStorage("dairy_list") private var savedDairy: String = ""
    @AppStorage("meat_list") private var savedMeat: String = ""
    @AppStorage("produce_list") private var savedProduce: String = ""
    @AppStorage("snack_list") private var savedSnacks: String = ""
    @AppStorage("dessert_list") private var savedDesserts: String = ""
    
   //make your own categories
    @AppStorage("custom_categories") private var customCategories: String = ""
    @AppStorage("custom_items_storage") private var customItemsStorage: String = ""

    @State private var newCategoryName = ""
    @State private var checkedItems: Set<String> = []

    // Temporary input text for standard sections
    @State private var newInputs: [String: String] = [:]

    var body: some View {
        List {
            // Standard Sections
            grocerySection(title: "Dairy", savedString: $savedDairy)
            grocerySection(title: "Meat", savedString: $savedMeat)
            grocerySection(title: "Produce", savedString: $savedProduce)
            grocerySection(title: "Snacks", savedString: $savedSnacks)
            grocerySection(title: "Desserts", savedString: $savedDesserts)

            // 3. NEW: Show Custom Categories created by the user
            let categories = customCategories.components(separatedBy: ",").filter { !$0.isEmpty }
            ForEach(categories, id: \.self) { catName in
                Section(catName) {
                    Text("Ready for items...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            // 4. NEW: The "+" area to add a category you missed
            Section("Missing something?") {
                HStack {
                    TextField("New category name...", text: $newCategoryName)
                    Button {
                        if !newCategoryName.isEmpty {
                            customCategories += (customCategories.isEmpty ? "" : ",") + newCategoryName
                            newCategoryName = ""
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            
            Button("Clear All", role: .destructive) {
                savedDairy = ""; savedMeat = ""; savedProduce = ""; savedSnacks = ""; savedDesserts = ""
                customCategories = ""
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
            // Simple text input for the section
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
