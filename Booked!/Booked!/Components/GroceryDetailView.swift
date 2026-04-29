import SwiftUI

struct GroceryDetailView: View {
    @AppStorage("dairy_list") private var savedDairy: String = ""
    @AppStorage("meat_list") private var savedMeat: String = ""
    @AppStorage("produce_list") private var savedProduce: String = ""
    @AppStorage("snack_list") private var savedSnacks: String = ""
    @AppStorage("dessert_list") private var savedDesserts: String = ""

    @AppStorage("custom_categories") private var customCategories: String = ""
    
    @State private var newInputs: [String: String] = [:]
    @State private var checkedItems: Set<String> = []
    @State private var newCategoryName: String = ""

    var body: some View {
        List {
     
            grocerySection(title: "Dairy", savedString: $savedDairy)
            grocerySection(title: "Meat", savedString: $savedMeat)
            grocerySection(title: "Produce", savedString: $savedProduce)
            grocerySection(title: "Snacks", savedString: $savedSnacks)
            grocerySection(title: "Desserts", savedString: $savedDesserts)
            
 
            let customTitles = customCategories.components(separatedBy: ",").filter { !$0.isEmpty }
            ForEach(customTitles, id: \.self) { title in
                // We use a custom binding to interface with AppStorage dynamically
                grocerySection(title: title, savedString: Binding(
                    get: { UserDefaults.standard.string(forKey: "custom_list_\(title)") ?? "" },
                    set: { UserDefaults.standard.set($0, forKey: "custom_list_\(title)") }
                ))
            }


            Section("Add New Category") {
                HStack {
                    TextField("Category name (e.g. Frozen)", text: $newCategoryName)
                    Button(action: addCategory) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                    .disabled(newCategoryName.isEmpty)
                }
            }
            
            Button("Clear All", role: .destructive) {
                savedDairy = ""; savedMeat = ""; savedProduce = ""; savedSnacks = ""; savedDesserts = ""
                customCategories = "" // This clears the custom titles
                checkedItems.removeAll()
            }
        }
        .navigationTitle("Groceries")
    }


    
    private func addCategory() {
        let trimmed = newCategoryName.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty {
            if customCategories.isEmpty {
                customCategories = trimmed
            } else {
                customCategories += ",\(trimmed)"
            }
            newCategoryName = ""
        }
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
