//
//  SchoolClassDashboard.swift
//  Booked!
//
//  Created by gwen bradshaw on 3/30/26.
//
import SwiftUI


struct SchoolClassDashboard: View {
    @AppStorage("semester_classes") private var classesString = ""
    @State private var showingAddSheet = false
    @State private var showingResetAlert = false
    
    var classes: [String] {
        classesString.components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
    
    let pastelColors: [Color] = [
        Color(red: 0.85, green: 0.93, blue: 1.0), // Pastel Blue
        Color(red: 1.0, green: 0.88, blue: 0.88), // Pastel Pink
        Color(red: 0.88, green: 1.0, blue: 0.88), // Pastel Green
        Color(red: 1.0, green: 0.95, blue: 0.85), // Pastel Peach
        Color(red: 0.93, green: 0.88, blue: 1.0)  // Pastel Lavender
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // HEADER
                VStack(alignment: .leading, spacing: 5) {
                    Text("My Semester")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                    Text("Organize your courses and deadlines.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 20)

                if classes.isEmpty {
                    // AESTHETIC EMPTY STATE
                    VStack(spacing: 20) {
                        Image(systemName: "book.closed.circle")
                            .font(.system(size: 80))
                            .foregroundColor(.secondary.opacity(0.3))
                        Text("No classes yet")
                            .font(.headline)
                        Button(action: { showingAddSheet = true }) {
                            Text("Add Your First Class")
                                .fontWeight(.bold)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(15)
                        }
                    }
                    .padding(.top, 60)
                } else {
                    // VERTICAL PASTEL CARDS
                    VStack(spacing: 15) {
                        ForEach(Array(classes.enumerated()), id: \.offset) { index, name in
                            NavigationLink(destination: TaskMatrixView(mode: "School", specificClass: name)) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(name)
                                            .font(.title2).bold()
                                            .foregroundColor(.black.opacity(0.7))
                                        Text("View Assignments")
                                            .font(.caption)
                                            .foregroundColor(.black.opacity(0.5))
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.black.opacity(0.3))
                                }
                                .padding(25)
                                .background(pastelColors[index % pastelColors.count])
                                .cornerRadius(20)
                            }
                        }
                        
                        Button(action: { showingAddSheet = true }) {
                            Label("Add Class", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .padding()
                        }
                        
                        // NEW SEMESTER RESET
                        Button(role: .destructive, action: { showingResetAlert = true }) {
                            Text("Start New Semester")
                                .font(.caption2).bold()
                                .opacity(0.5)
                        }
                        .padding(.top, 40)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddClassSheet(classesString: $classesString)
                .presentationDetents([.height(250)])
        }
        .alert("Start New Semester?", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear Everything", role: .destructive) {
                classesString = ""
                UserDefaults.standard.removeObject(forKey: "tasks_School")
            }
        } message: {
            Text("This will delete all classes and their assignments permanently.")
        }
    }
}

struct AddClassSheet: View {
    @Binding var classesString: String
    @State private var name = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Class").font(.headline)
            TextField("Class Name", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding()
            Button("Save Class") {
                if !name.isEmpty {
                    classesString += (classesString.isEmpty ? "" : ",") + name
                    dismiss()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
