//
//  AddEventSheet.swift
//  Booked!
//
//  Created by gwen bradshaw on 2/12/26.
//
import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct AddEventSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var eventTitle: String = ""
    @State private var selectedDate = Date()
    @State private var selectedState: AppMode = .work
    @State private var selectedType = "Meeting"
    @State private var notificationsEnabled: Bool = true
    @State private var reminderOffset: Int = 0
    
    // NEW: Special Event States
    @State private var isSpecialEvent: Bool = false
    @State private var categoryName: String = ""
    @State private var selectedColorHex: String = "#BFFCC6"
    
    let reminderOptions = [
        ("At time of event", 0),
        ("30 minutes before event", 30),
        ("1 hour before event", 60),
        ("1 day before", 1440)
    ]
    
    let pastelPalette = ["#BFFCC6", "#E0BBE4", "#A1C4FD", "#FFCCBB", "#FFFFD1"]
    @State private var selectedRepeatDays: Set<Int> = []
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Event Details") {
                    TextField("Title", text: $eventTitle)
                    DatePicker("Date", selection: $selectedDate)
                }
                
                Section("Events Screen Appearance") {
                    Toggle("Mark as Special Event", isOn: $isSpecialEvent)
                    if isSpecialEvent {
                        TextField("Category (e.g., Birthday)", text: $categoryName)
                        HStack {
                            Text("Color")
                            Spacer()
                            ForEach(pastelPalette, id: \.self) { hex in
                                Circle()
                                    .fill(Color(hex: hex))
                                    .frame(width: 24, height: 24)
                                    .overlay(Circle().stroke(Color.secondary, lineWidth: selectedColorHex == hex ? 2 : 0))
                                    .onTapGesture { selectedColorHex = hex }
                            }
                        }
                    }
                }

                Section("Repeat on") {
                    HStack (spacing: 0) {
                        ForEach(1...7, id:\.self) { day in
                            Text(String(daysOfWeek[day - 1].prefix(1)))
                                .font(.caption)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .frame(height:35)
                                .background(selectedRepeatDays.contains(day) ? selectedState.themeColor : Color.secondary.opacity(0.2))
                                .foregroundColor(selectedRepeatDays.contains(day) ? .white : .primary)
                                .clipShape(Circle())
                                .onTapGesture {
                                    if selectedRepeatDays.contains(day) { selectedRepeatDays.remove(day) }
                                    else { selectedRepeatDays.insert(day) }
                                }
                        }
                    }
                }

                Section("Category") {
                    Picker("State", selection: $selectedState) {
                        ForEach(AppMode.allCases, id: \.self) { state in
                            Text(state.rawValue).tag(state)
                        }
                    }
                }
            }
            .navigationTitle("Add Event")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newEvent = CalendarEvent(
                            title: eventTitle,
                            timestamp: selectedDate,
                            eventType: selectedType,
                            stateGroup: selectedState.rawValue,
                            repeatDays: Array(selectedRepeatDays),
                            categoryName: isSpecialEvent ? categoryName : nil,
                            categoryColor: isSpecialEvent ? selectedColorHex : nil
                        )
                        modelContext.insert(newEvent)
                        dismiss()
                    }
                    .disabled(eventTitle.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
