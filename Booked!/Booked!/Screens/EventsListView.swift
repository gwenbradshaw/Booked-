//
//  EventsListView.swift
//  Booked!
//
//  Created by gwen bradshaw on 4/13/26.
//


import SwiftUI
import SwiftData

struct EventsListView: View {

    @Query private var allEvents: [CalendarEvent]

    var specialEvents: [CalendarEvent] {
        allEvents.filter { event in
            let isValidCategory = event.categoryName != nil
            let isSpecialState = ["Personal", "Work", "School"].contains(event.stateGroup)
            
            return isValidCategory && isSpecialState
        }
        .sorted { $0.timestamp < $1.timestamp }
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                if specialEvents.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "sparkles")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No Special Events Yet")
                            .font(.headline)
                        Text("When you add an event to your calendar, give it a category like 'Trip' or 'Birthday' to see it here.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .padding(40)
                } else {
                    ForEach(specialEvents) { event in
                        EventRow(event: event)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Upcoming Events")
        .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
    }
}

