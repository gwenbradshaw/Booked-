//
//  RecommendationsView.swift
//  Booked!
//
//  Created by gwen bradshaw on 4/7/26.
//


import SwiftUI


struct RecommendationsView: View {
    @AppStorage("user_recommendations") private var recsData: String = "[]"
    
    // State to track which category we are currently adding to
    @State private var categoryToAdd: RecCategory? = nil
    @State private var newTitle = ""
    @State private var newNote = ""

    var allRecs: [Recommendation] {
        guard let data = recsData.data(using: .utf8) else { return [] }
        return (try? JSONDecoder().decode([Recommendation].self, from: data)) ?? []
    }

    var body: some View {
        List {
            //  QUICK ADD OPTIONS
            Section("Add New Recommendation") {
                ForEach(RecCategory.allCases) { cat in
                    Button(action: { categoryToAdd = cat }) {
                        HStack {
                            Image(systemName: cat.icon)
                                .foregroundColor(.purple)
                                .frame(width: 30)
                            Text("Add \(cat.rawValue)")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.purple.opacity(0.5))
                        }
                    }
                }
            }

            // THE SAVED LIST
            Section("My Recommendations") {
                if allRecs.isEmpty {
                    Text("No recommendations yet.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    // Grouped by Category automatically or just a long list
                    ForEach(allRecs) { rec in
                        HStack {
                            Image(systemName: rec.category.icon)
                                .foregroundColor(.purple)
                                .frame(width: 25)
                            
                            VStack(alignment: .leading) {
                                Text(rec.title)
                                    .font(.system(.body, design: .rounded)).bold()
                                    .strikethrough(rec.isDone)
                                
                                if !rec.note.isEmpty {
                                    Text(rec.note)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            Button { toggleDone(rec) } label: {
                                Image(systemName: rec.isDone ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(rec.isDone ? .green : .gray.opacity(0.3))
                                    .font(.title3)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deleteRec)
                }
            }
        }
        .navigationTitle("Recs")
        // --- INPUT ALERT / SHEET ---
        .sheet(item: $categoryToAdd) { cat in
            addSheet(for: cat)
        }
    }

    // MARK: - Helper Views
    
    @ViewBuilder
    func addSheet(for cat: RecCategory) -> some View {
        NavigationStack {
            Form {
                Section("Details for \(cat.rawValue)") {
                    TextField("Title (Name of \(cat.rawValue))", text: $newTitle)
                    TextField("Notes (For someone specific?)", text: $newNote)
                }
            }
            .navigationTitle("New \(cat.rawValue)")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveNewRec(category: cat)
                    }
                    .disabled(newTitle.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { categoryToAdd = nil; newTitle = ""; newNote = "" }
                }
            }
        }
        .presentationDetents([.medium]) // Makes the sheet only take up half the screen
    }

    // MARK: - Logic functions
    
    func saveNewRec(category: RecCategory) {
        var current = allRecs
        let new = Recommendation(title: newTitle, note: newNote, category: category)
        current.insert(new, at: 0) // Put newest at the top
        save(current)
        
        // Reset and close
        newTitle = ""
        newNote = ""
        categoryToAdd = nil
    }

    func toggleDone(_ rec: Recommendation) {
            var current = allRecs
            if let index = current.firstIndex(where: { $0.id == rec.id }) {
                withAnimation {
                    current[index].isDone.toggle()
                }
                save(current)
            }
        }

        func deleteRec(at offsets: IndexSet) {
            var current = allRecs
            current.remove(atOffsets: offsets)
            save(current)
        }

        func save(_ list: [Recommendation]) {
            if let data = try? JSONEncoder().encode(list) {
                recsData = String(data: data, encoding: .utf8) ?? "[]"
            }
        }
    }
