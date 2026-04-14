//
//  To-DoView.swift
//  Booked!
//
//  Created by gwen bradshaw on 2/26/26.
//
import SwiftUI


// The Template Types
enum ListTemplate: String, CaseIterable, Codable {
    case blank = "Blank"
    case groceries = "Groceries"
    case gym = "Gym"
    case brainDump = "Brain Dump"
    case routine = "Daily Routine"
    
    var icon: String {
        switch self {
        case .blank: return "checklist"
        case .groceries: return "cart.fill"
        case .gym: return "figure.run"
        case .brainDump: return "brain.head.profile"
        case .routine: return "clock.fill"
        }
    }
}

struct To_DoView: View {
    @AppStorage("todo_categories_v2") private var categoriesData: String = "[]"
    @State private var newCategoryName = ""
    @State private var selectedTemplate: ListTemplate = .blank


    var categories: [ToDoCategory] {
        guard let data = categoriesData.data(using: .utf8) else { return [] }
        return (try? JSONDecoder().decode([ToDoCategory].self, from: data)) ?? []
    }

    var body: some View {
        NavigationStack {
            List {
                // TEMPLATE GALLERY
                Section("Choose a Template") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(ListTemplate.allCases, id: \.self) { template in
                                templateButton(template)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.clear)
                }

                // CREATE NEW LIST
                Section {
                    HStack {
                        TextField("Name your \(selectedTemplate.rawValue) list...", text: $newCategoryName)
                            .textInputAutocapitalization(.words)
                        
                        Button(action: addCategory) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                                .foregroundColor(.purple)
                        }
                        .disabled(newCategoryName.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                } header: {
                    Text("Create New \(selectedTemplate.rawValue) List")
                }

                //SAVED LISTS
                Section("My Lists") {
                    if categories.isEmpty {
                        Text("No lists yet. Pick a template above!")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(categories) { category in
                            NavigationLink(destination: destinationView(for: category)) {
                                Label(category.name, systemImage: category.template.icon)
                            }
                        }
                        .onDelete(perform: deleteCategory)
                    }
                }
            }
            .navigationTitle("To-do's")
            .toolbar { EditButton() }
        }
    }

    // Subviews & Logic

    @ViewBuilder
    func templateButton(_ template: ListTemplate) -> some View {
        Button {
            withAnimation(.spring()) { selectedTemplate = template }
        } label: {
            VStack(spacing: 8) {
                Image(systemName: template.icon)
                    .font(.system(size: 24))
                Text(template.rawValue)
                    .font(.system(size: 10, weight: .bold))
            }
            .frame(width: 85, height: 75)
            .background(selectedTemplate == template ? Color.purple : Color.purple.opacity(0.1))
            .foregroundColor(selectedTemplate == template ? .white : .purple)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.purple.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    func destinationView(for category: ToDoCategory) -> some View {
        switch category.template {
        case .groceries:
            GroceryDetailView()
        case .gym:
            GymView()
        case .brainDump:
            BrainDumpView(title: category.name)
        case .routine:
            DailyRoutineView(title: category.name)
        case .blank:
            UniversalListView(title: category.name)
        }
    }

    func addCategory() {
        let trimmedName = newCategoryName.trimmingCharacters(in: .whitespaces)
        var currentCategories = categories
        let newCategory = ToDoCategory(name: trimmedName, template: selectedTemplate)
        
        currentCategories.append(newCategory)
        save(currentCategories)
        
        // Reset inputs
        newCategoryName = ""
        selectedTemplate = .blank
    }

    func deleteCategory(at offsets: IndexSet) {
        var currentCategories = categories
        currentCategories.remove(atOffsets: offsets)
        save(currentCategories)
    }

    func save(_ list: [ToDoCategory]) {
        if let data = try? JSONEncoder().encode(list) {
            categoriesData = String(data: data, encoding: .utf8) ?? "[]"
        }
    }
}
