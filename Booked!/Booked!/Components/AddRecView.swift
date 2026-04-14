//
//  AddRecView.swift
//  Booked!
//
//  Created by gwen bradshaw on 4/7/26.
//
import SwiftUI

struct AddRecView: View {
    @Environment(\.dismiss) var dismiss
    var onAdd: (Recommendation) -> Void
    
    @State private var title = ""
    @State private var note = ""
    @State private var category: RecCategory = .movie

    var body: some View {
        NavigationStack {
            Form {
                TextField("Title (e.g. Inception)", text: $title)
                TextField("Note (Who recommended it?)", text: $note)
                
                Picker("Category", selection: $category) {
                    ForEach(RecCategory.allCases) { cat in
                        Text(cat.rawValue).tag(cat)
                    }
                }
            }
            .navigationTitle("New Recommendation")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let new = Recommendation(title: title, note: note, category: category)
                        onAdd(new)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
