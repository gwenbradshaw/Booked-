//
//  NotesView.swift
//  Booked!
//
//  Created by gwen bradshaw on 2/26/26.
//

import SwiftUI

struct NotesView: View {
    // Saves all notes 
    @AppStorage("saved_notes_list") private var savedNotes: String = ""
    @State private var showingAddNote = false

    var body: some View {
        NavigationStack {
            List {
                let notesArray = savedNotes.components(separatedBy: "|||").filter { !$0.isEmpty }
                
                ForEach(notesArray, id: \.self) { note in
                    // Tapping a note opens that specific "file"
                    NavigationLink(destination: NoteDetailView(initialText: note, allNotes: $savedNotes)) {
                        VStack(alignment: .leading) {
                            Text(note.components(separatedBy: "\n").first ?? "New Note")
                                .font(.headline)
                                .lineLimit(1)
                            Text(note)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
                .onDelete(perform: deleteNote) // Swipe to delete a file!
            }
            .navigationTitle("My Notes")
            .toolbar {
                Button { showingAddNote = true } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddNote) {
                AddNoteSheet(allNotes: $savedNotes)
            }
        }
    }

    func deleteNote(at offsets: IndexSet) {
        var notesArray = savedNotes.components(separatedBy: "|||").filter { !$0.isEmpty }
        notesArray.remove(atOffsets: offsets)
        savedNotes = notesArray.joined(separator: "|||")
    }
}
