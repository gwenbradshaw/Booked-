//
//  UniversalListView.swift
//  Booked!
//
//  Created by gwen bradshaw on 4/7/26.
//


import SwiftUI

struct UniversalListView: View {
    let title: String
    @AppStorage private var savedItems: String
    @State private var newItemName = ""
    @State private var checkedItems: Set<String> = []

    init(title: String) {
        self.title = title
        // Creates a unique storage key for every custom list name
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