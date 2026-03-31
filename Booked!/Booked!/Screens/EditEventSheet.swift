//
//  EditEventSheet.swift
//  Booked!
//
//  Created by gwen bradshaw on 3/26/26.
//

import SwiftUI
import SwiftData

struct EditEventView: View {
    @Bindable var event: CalendarEvent
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            Section(header: Text("Event Details")) {
                TextField("Title", text: $event.title)
                TextField("Type", text: $event.eventType)
            }
            
            Section(header: Text("Schedule")) {
                DatePicker("Date", selection: $event.timestamp)
            }
            
            Section(header: Text("Category")) {
                Picker("Group", selection: $event.stateGroup) {
                    Text("Personal").tag("Personal")
                    Text("Work").tag("Work")
                    Text("School").tag("School")
                }
                .pickerStyle(.segmented)
            }
            
            Section {
                Button(role: .destructive) {
                    deleteAndDismiss()
                } label: {
                    HStack{
                        Spacer()
                        Text("Delete Event")
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Edit Event")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .confirmationAction){
                Button("Done"){
                    dismiss()
                }
            }
        }
    }
    private func deleteAndDismiss(){
        modelContext.delete(event)
        dismiss()
    }
}
