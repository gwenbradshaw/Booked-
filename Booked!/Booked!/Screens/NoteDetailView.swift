//
//  NoteDetailView.swift
//  Booked!
//
//  Created by gwen bradshaw on 2/27/26.
//
import SwiftUI

struct NoteDetailView: View {
    @State var currentText: String
    @Binding var allNotes: String
    let originalText: String

    init(initialText: String, allNotes: Binding<String>) {
        self._currentText = State(initialValue: initialText)
        self._allNotes = allNotes
        self.originalText = initialText
    }

    var body: some View {
        TextEditor(text: $currentText)
            .padding()
            .navigationTitle("Edit Note")
            .onDisappear {
                // When you leave the screen, it saves the changes
                saveChanges()
            }
    }

    func saveChanges() {
        var notesArray = allNotes.components(separatedBy: "|||")
        if let index = notesArray.firstIndex(of: originalText) {
            notesArray[index] = currentText
            allNotes = notesArray.joined(separator: "|||")
        }
    }
}
