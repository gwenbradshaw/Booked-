import SwiftUI

struct AddNoteSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var allNotes: String
    @State private var text = ""

    var body: some View {
        NavigationStack {
            TextEditor(text: $text)
                .padding()
                .navigationTitle("New Note")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            if !text.isEmpty {
                                allNotes += (allNotes.isEmpty ? "" : "|||") + text
                            }
                            dismiss()
                        }
                    }
                }
        }
    }
}
