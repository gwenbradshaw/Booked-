//
//  To-DoView.swift
//  Booked!
//
//  Created by gwen bradshaw on 2/26/26.
//

import SwiftUI

struct To_DoView: View {
    @AppStorage("todo_categories") private var categoriesString: String = "Groceries,Gym"
    @State private var newCategoryName = ""

    var categories: [String] {
        categoriesString.components(separatedBy: ",").filter { !$0.isEmpty }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(categories, id: \.self) { category in
                    NavigationLink(destination: destinationView(for: category)) {
                        Label(category, systemImage: getIcon(for: category))
                    }
                }
                .onDelete(perform: deleteCategory)

                Section("Create New List") {
                    HStack {
                        TextField("List name...", text: $newCategoryName)
                        Button(action: addCategory) {
                            Image(systemName: "plus.circle.fill")
                        }
                        .disabled(newCategoryName.isEmpty)
                    }
                }
            }
            .navigationTitle("To-do's")
            .toolbar { EditButton() }
        }
    }

    @ViewBuilder
    func destinationView(for name: String) -> some View {
        if name == "Groceries" {
            GroceryDetailView()
        } else if name == "Gym" {
            GymView()
        } else {
            UniversalListView(title: name)
        }
    }

    func addCategory() {
        let trimmed = newCategoryName.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty && !categories.contains(trimmed) {
            categoriesString += (categoriesString.isEmpty ? "" : ",") + trimmed
            newCategoryName = ""
        }
    }

    func deleteCategory(at offsets: IndexSet) {
        var tempArray = categories
        tempArray.remove(atOffsets: offsets)
        categoriesString = tempArray.joined(separator: ",")
    }

    func getIcon(for name: String) -> String {
        switch name.lowercased() {
        case "groceries": return "cart"
        case "gym": return "figure.run"
        default: return "checklist"
        }
    }
}

    // GROCERY VIEW
struct GroceryDetailView: View {
    @AppStorage("dairy_list") private var savedDairy: String = ""
    @AppStorage("meat_list") private var savedMeat: String = ""
    @AppStorage("produce_list") private var savedProduce: String = ""
    @AppStorage("snack_list") private var savedSnacks: String = ""
    @AppStorage("dessert_list") private var savedDesserts: String = ""
    
    @AppStorage("custom_categories") private var customCategories: String = ""
    @State private var newCategoryName = ""
    @State private var checkedItems: Set<String> = []
    @State private var newInputs: [String: String] = [:]

    var body: some View {
        List {
            grocerySection(title: "Dairy", savedString: $savedDairy)
            grocerySection(title: "Meat", savedString: $savedMeat)
            grocerySection(title: "Produce", savedString: $savedProduce)
            grocerySection(title: "Snacks", savedString: $savedSnacks)
            grocerySection(title: "Desserts", savedString: $savedDesserts)

            let customCats = customCategories.components(separatedBy: ",").filter { !$0.isEmpty }
            ForEach(customCats, id: \.self) { catName in
                Section(catName) {
                    Text("Ready for items...").font(.caption).foregroundStyle(.secondary)
                }
            }

            Section("Missing something?") {
                HStack {
                    TextField("New category name...", text: $newCategoryName)
                    Button {
                        if !newCategoryName.isEmpty {
                            customCategories += (customCategories.isEmpty ? "" : ",") + newCategoryName
                            newCategoryName = ""
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill").foregroundColor(.blue)
                    }
                }
            }
            
            Button("Clear All", role: .destructive) {
                savedDairy = ""; savedMeat = ""; savedProduce = ""; savedSnacks = ""; savedDesserts = ""
                customCategories = ""; checkedItems.removeAll()
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

// VIEW FOR CUSTOM LISTS 
struct UniversalListView: View {
    let title: String
    @AppStorage private var savedItems: String
    @State private var newItemName = ""
    @State private var checkedItems: Set<String> = []

    init(title: String) {
        self.title = title
        self._savedItems = AppStorage(wrappedValue: "", "custom_list_\(title)")
    }

    var body: some View {
        List {
            let items = savedItems.components(separatedBy: ",").filter { !$0.isEmpty }
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
            .onDelete(perform: deleteItem)

            TextField("Add to \(title)...", text: $newItemName)
                .onSubmit {
                    if !newItemName.isEmpty {
                        savedItems += (savedItems.isEmpty ? "" : ",") + newItemName
                        newItemName = ""
                    }
                }
        }
        .navigationTitle(title)
    }

    func deleteItem(at offsets: IndexSet) {
        var items = savedItems.components(separatedBy: ",").filter { !$0.isEmpty }
        items.remove(atOffsets: offsets)
        savedItems = items.joined(separator: ",")
    }
}
