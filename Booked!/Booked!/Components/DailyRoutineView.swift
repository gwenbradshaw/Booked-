import SwiftUI

struct DailyRoutineView: View {
    let title: String
    @AppStorage private var savedRoutine: String

    @State private var newTime: String = ""
    @State private var newTask: String = ""

    init(title: String) {
        self.title = title
        self._savedRoutine = AppStorage(wrappedValue: "", "routine_\(title)")
    }

    var body: some View {
        List {
            Section("My Timeline") {
                let items = savedRoutine.components(separatedBy: "|").filter { !$0.isEmpty }
                
                if items.isEmpty {
                    Text("No tasks added yet.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                ForEach(items, id: \.self) { item in
                    let parts = item.components(separatedBy: ":")
                    HStack {
                        Text(parts.first ?? "")
                            .bold()
                            .frame(width: 80, alignment: .leading)
                            .foregroundColor(.blue)
                        
                        Text(parts.count > 1 ? parts[1] : "")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            
            Section("Add To Routine") {
                HStack {
                    TextField("8:00 AM", text: $newTime)
                        .frame(width: 90)
                    
                    Divider()
                    
                    TextField("Morning Walk", text: $newTask)
                }
                
                Button(action: addTask) {
                    HStack {
                        Spacer()
                        Label("Add to Schedule", systemImage: "plus")
                        Spacer()
                    }
                }
                .disabled(newTime.isEmpty || newTask.isEmpty)
            }
            
            Section {
                Button("Reset Timeline", role: .destructive) {
                    savedRoutine = ""
                }
            }
        }
        .navigationTitle(title)
        .toolbar {
            EditButton()
        }
    }

    
    private func addTask() {
        // Clean up input and format as "Time:Task"
        let entry = "\(newTime.trimmingCharacters(in: .whitespaces)):\(newTask.trimmingCharacters(in: .whitespaces))"
        
        if savedRoutine.isEmpty {
            savedRoutine = entry
        } else {
            savedRoutine += "|\(entry)"
        }
        
        // Reset inputs
        newTime = ""
        newTask = ""
    }
    
    private func deleteItems(at offsets: IndexSet) {
        var items = savedRoutine.components(separatedBy: "|").filter { !$0.isEmpty }
        items.remove(atOffsets: offsets)
        savedRoutine = items.joined(separator: "|")
    }
}
