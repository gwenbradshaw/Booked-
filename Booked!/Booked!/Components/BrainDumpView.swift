//
//  BrainDumpView.swift
//  Booked!
//
//  Created by gwen bradshaw on 4/7/26.
//

import SwiftUI

struct BrainDumpView: View {
    let title: String
    
    
    @AppStorage private var q1: String
    @AppStorage private var q2: String
    @AppStorage private var q3: String
    @AppStorage private var q4: String

    init(title: String) {
        self.title = title
        self._q1 = AppStorage(wrappedValue: "", "bd_\(title)_urgent_important")
        self._q2 = AppStorage(wrappedValue: "", "bd_\(title)_important_not_urgent")
        self._q3 = AppStorage(wrappedValue: "", "bd_\(title)_urgent_not_important")
        self._q4 = AppStorage(wrappedValue: "", "bd_\(title)_neither")
    }

    var body: some View {
        List {
            brainSection(title: "Do Now", subtitle: "Urgent & Important", color: .red, savedString: $q1)
            brainSection(title: "Schedule", subtitle: "Important, Not Urgent", color: .blue, savedString: $q2)
            brainSection(title: "Delegate", subtitle: "Urgent, Not Important", color: .orange, savedString: $q3)
            brainSection(title: "Delete", subtitle: "Neither", color: .secondary, savedString: $q4)
        }
        .navigationTitle(title)
    }

    @ViewBuilder
    func brainSection(title: String, subtitle: String, color: Color, savedString: Binding<String>) -> some View {
        Section(header: Text(title).foregroundColor(color).bold()) {
            Text(subtitle).font(.caption2).italic().foregroundColor(.secondary)
            
            // UniversalListView
            let items = savedString.wrappedValue.components(separatedBy: ",").filter { !$0.isEmpty }
            ForEach(items, id: \.self) { item in
                Text(item)
            }
            .onDelete { offsets in
                var array = items
                array.remove(atOffsets: offsets)
                savedString.wrappedValue = array.joined(separator: ",")
            }

            TextField("Add to \(title)...", text: .constant(""))
                .onSubmit {
                    // Logic to append to savedString here
                }
        }
    }
}
