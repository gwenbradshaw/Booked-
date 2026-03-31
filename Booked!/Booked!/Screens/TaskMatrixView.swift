//
//  TaskMatrixView.swift
//  Booked!
//
//  Created by gwen bradshaw on 3/30/26.
//
import SwiftUI
import SwiftUI

struct TaskMatrixView: View {
    let mode: String
    let specificClass: String?
    
    @AppStorage("temp_key") private var savedTasksData: Data = Data()
    @State private var tasks: [UniversalTask] = []
    @State private var newTaskTitle = ""
    @State private var selectedDate = Date()
    @State private var showConfetti = false

    init(mode: String, specificClass: String?) {
        self.mode = mode
        self.specificClass = specificClass
        let storageKey = "tasks_v_FINAL_\(mode)"
        self._savedTasksData = AppStorage(wrappedValue: Data(), storageKey)
    }

    var body: some View {
        ZStack {
            List {
                Section("New Assignment") {
                    VStack(spacing: 12) {
                        TextField("Title", text: $newTaskTitle)
                            .textFieldStyle(.roundedBorder)
                        DatePicker("Due Date", selection: $selectedDate, displayedComponents: .date)
                        Button(action: addTask) {
                            Text("Add to List")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(newTaskTitle.isEmpty)
                    }
                    .padding(.vertical, 5)
                }

                Section("In Progress") {
                    let active = tasks.filter { !$0.isCompleted && (specificClass == nil || $0.className == specificClass) }
                    if active.isEmpty {
                        Text("All caught up!").font(.caption).italic().foregroundColor(.secondary)
                    }
                    ForEach(active) { task in
                        taskRow(task)
                    }
                }

                Section("Completed") {
                    let completed = tasks.filter { $0.isCompleted && (specificClass == nil || $0.className == specificClass) }
                    ForEach(completed) { task in
                        HStack {
                            Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                            Text(task.title).strikethrough().foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: deleteCompleted)
                }
            }

            if showConfetti {
                VStack {
                    Text("🎉")
                        .font(.system(size: 70))
                    Text("WELL DONE!")
                        .font(.headline).bold()
                        .foregroundColor(.blue)
                }
                .padding(30)
                .background(Color.white.cornerRadius(20).shadow(radius: 10))
                .transition(.scale)
            }
        }
        .navigationTitle(specificClass ?? "Tasks")
        .onAppear(perform: loadTasks)
    }

    func taskRow(_ task: UniversalTask) -> some View {
        let isClose = Calendar.current.isDateInToday(task.dueDate) || Calendar.current.isDateInTomorrow(task.dueDate)
        
        return HStack {
            Button(action: { completeTask(task) }) {
                Image(systemName: "circle")
                    .font(.title3)
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(task.title).bold()
                    if isClose { Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.orange) }
                }
                Text(task.dueDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(task.dueDate < Date() && !Calendar.current.isDateInToday(task.dueDate) ? .red : .secondary)
            }
            .padding(.leading, 8)
        }
    }

    func completeTask(_ task: UniversalTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            withAnimation {
                tasks[index].isCompleted = true
                showConfetti = true
                saveTasks()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation { showConfetti = false }
                }
            }
        }
    }

    func addTask() {
        let newTask = UniversalTask(title: newTaskTitle, status: "Active", dueDate: selectedDate, className: specificClass ?? "", isCompleted: false)
        tasks.append(newTask)
        saveTasks()
        newTaskTitle = ""
    }

    func deleteCompleted(at offsets: IndexSet) {
        let completed = tasks.filter { $0.isCompleted && (specificClass == nil || $0.className == specificClass) }
        for index in offsets {
            let id = completed[index].id
            tasks.removeAll(where: { $0.id == id })
        }
        saveTasks()
    }
    
    func saveTasks() { if let encoded = try? JSONEncoder().encode(tasks) { savedTasksData = encoded } }
    func loadTasks() { if let decoded = try? JSONDecoder().decode([UniversalTask].self, from: savedTasksData) { tasks = decoded } }
}
