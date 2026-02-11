//
//  CalendarView.swift
//  Booked!
//
//  Created by gwen bradshaw on 2/11/26.
//
import SwiftUI

struct CalendarView: View {
    //calendar to change color based on app mode
    let mode: AppMode
    @State private var selectedDate = Date()
    @Environment(\.dismiss) var dismiss //ability to close screen
    
    var body: some View {
        NavigationStack{
            VStack{
                DatePicker(
                    "Select Date", selection:  $selectedDate, displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .accentColor(mode.themeColor)
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.secondary.opacity(0.1)))
                .padding()
                
                List{
                    Section(header: Text("Scheduled for \(selectedDate.formatted(date: .abbreviated, time: .omitted))")) {
                        
                        Label("Meeting", systemImage: "person.2.fill")
                        Label("Work Task", systemImage: "checklist")
                        Label("Other", systemImage: "square").foregroundColor(mode.themeColor)
                    }
                }
                .listStyle(.insetGrouped)
                
            }
            .navigationTitle("\(mode.rawValue) Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Done"){
                        dismiss()}
                    }
                }
            }
        }
    }
    #Preview{
        CalendarView(mode: .school)
}
    

