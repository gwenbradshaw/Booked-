//
//  WorkDashboard.swift
//  Booked!
//
//  Created by gwen bradshaw on 3/30/26.
//
import SwiftUI
import SwiftUI

struct WorkDashboard: View {
    @AppStorage("work_categories") private var categoriesString = "Projects,Meetings,Admin"
    @State private var showingAddSheet = false
    @State private var showingResetAlert = false
    
    var categories: [String] {
        categoriesString.components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
    
    // Professional "Work" Pastels (Cooler Mint & Slate tones)
    let workPastels: [Color] = [
        Color(red: 0.88, green: 0.95, blue: 0.92), // Mint
        Color(red: 0.92, green: 0.92, blue: 0.98), // Lavender Grey
        Color(red: 0.98, green: 0.94, blue: 0.88), // Sand
        Color(red: 0.88, green: 0.94, blue: 0.94), // Ice
        Color(red: 0.94, green: 0.94, blue: 0.94)  // Slate
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Work Flow")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                    Text("Track your professional deliverables.")
                        .font(.subheadline).foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal).padding(.top, 20)

                VStack(spacing: 15) {
                    ForEach(Array(categories.enumerated()), id: \.offset) { index, name in
                        NavigationLink(destination: TaskMatrixView(mode: "Work", specificClass: name)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(name).font(.title2).bold()
                                        .foregroundColor(.black.opacity(0.7))
                                    Text("Active Items").font(.caption)
                                        .foregroundColor(.black.opacity(0.5))
                                }
                                Spacer()
                                Image(systemName: "briefcase.fill").opacity(0.2)
                            }
                            .padding(25)
                            .background(workPastels[index % workPastels.count])
                            .cornerRadius(20)
                        }
                    }
                    
                    Button(action: { showingAddSheet = true }) {
                        Label("Add Category", systemImage: "plus.circle.fill").font(.headline).padding()
                    }
                    
                    Button(role: .destructive, action: { showingResetAlert = true }) {
                        Text("Reset Work Dashboard").font(.caption2).bold().opacity(0.4)
                    }
                    .padding(.top, 40)
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddWorkCategorySheet(categoriesString: $categoriesString)
                .presentationDetents([.height(250)])
        }
        .alert("Reset All Work?", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All", role: .destructive) {
                categoriesString = "Projects,Meetings,Admin"
                UserDefaults.standard.removeObject(forKey: "tasks_Work")
            }
        }
    }
}

struct AddWorkCategorySheet: View {
    @Binding var categoriesString: String
    @State private var name = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("New Category").font(.headline)
            TextField("e.g. Social Media, Research", text: $name).textFieldStyle(.roundedBorder).padding()
            Button("Add to Work") {
                if !name.isEmpty {
                    categoriesString += (categoriesString.isEmpty ? "" : ",") + name
                    dismiss()
                }
            }.buttonStyle(.borderedProminent)
        }.padding()
    }
}
