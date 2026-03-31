//
//  CalendarView.swift
//  Booked!
//
//  Created by gwen bradshaw on 2/11/26.
//
import SwiftUI
import SwiftData

struct CalendarView: View {
    //calendar to change color based on app mode
    let mode: AppMode
    @State private var selectedDate = Date()
    @State private var showingAddEvent = false
    @State private var showConfetti = false
    
    @Environment(\.dismiss) var dismiss //ability to close screen
    @Environment(\.modelContext) var modelContext // for deleting
    @Query(sort: \CalendarEvent.timestamp) private var allEvents: [CalendarEvent] //gets all events from the database
   
    
    //keeping calendar universal
    var filteredEvents: [CalendarEvent] {
        allEvents.filter { event in
         
            let isSameDay = Calendar.current.isDate(event.timestamp, inSameDayAs: selectedDate)
            
            let weekday = Calendar.current.component(.weekday, from: selectedDate)
            let isRepeatDay = event.repeatDays.contains(weekday)
            

            return isSameDay || isRepeatDay
        }
    }
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                   
                    CalendarWithDots(allEvents: allEvents, selectedDate: $selectedDate, themeColor: mode.themeColor)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.secondary.opacity(0.1)))
                        .padding()
                        .frame(height: 400) // UICalendarView needs a set height to look good
                        .id(allEvents.count)
                    
                    List{
                        Section(header: Text("Scheduled for \(selectedDate.formatted(date: .abbreviated, time: .omitted))")) {
                            if filteredEvents.isEmpty {
                                Text("No events for this day").foregroundColor(.secondary)
                            } else {
                                ForEach(filteredEvents){ event in
                                    NavigationLink(destination: EditEventView(event: event)){
                                        HStack{
                                            Button(action: {
                                                event.isCompleted.toggle()
                                                if event.isCompleted{
                                                    showConfetti = true
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                                                        showConfetti = false
                                                    }
                                                }
                                            }) {
                                                Image(systemName: event.isCompleted ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(event.isCompleted ? .green : mode.themeColor)
                                                    .font(.title3)
                                            }
                                            .buttonStyle(.plain)
                                            
                                            VStack(alignment: .leading) {
                                                Text(event.title)
                                                    .font(.headline)
                                                    .strikethrough(event.isCompleted)
                                                    .foregroundColor(event.isCompleted ? .secondary : .primary)
                                                Text(event.eventType)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                Text(event.stateGroup).font(.caption).foregroundColor(.secondary)
                                            }
                                            Spacer()
                                            Circle()
                                                .fill(event.stateGroup == "School" ? Color.blue :
                                                        event.stateGroup == "Work" ? Color.orange : Color.green)
                                                .frame(width: 10, height: 10)
                                        }
                                    }
                                }
                                .onDelete(perform: deleteEvents)
                                
                            }
                        }
                        
                    }
                    .listStyle(.insetGrouped)
                    
                }
                if showConfetti{
                    ConfettiView()
                }
            }
            .navigationTitle("\(mode.rawValue) Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Done"){
                        dismiss()}
                }
                
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: { showingAddEvent = true }){
                        Image(systemName: "plus")
                            .bold()
                            .foregroundColor(mode.themeColor)
                    }
                }
            }
            .sheet(isPresented: $showingAddEvent){
                AddEventSheet()
            }
        }
    }
    func deleteEvents (at offsets: IndexSet){
        for index in offsets{
            let event = filteredEvents[index]
            modelContext.delete(event)
        }
    }
    struct ConfettiView: View {
        @State private var animate = false
        
        var body: some View {
            ZStack {
                ForEach(0..<50) { i in
                    Rectangle()
                        .fill([Color.red, .blue, .green, .yellow, .pink, .orange].randomElement()!)
                        .frame(width: 10, height: 10)
                        .rotationEffect(.degrees(Double.random(in: 0...360)))
                        .offset(x: animate ? Double.random(in: -200...200) : 0,
                                y: animate ? Double.random(in: -500...500) : 0)
                        .opacity(animate ? 0 : 1)
                        .animation(.easeOut(duration: 1.5).delay(Double.random(in: 0...0.2)), value: animate)
                }
            }
            .onAppear { animate = true }
        }
    }
    
}

struct CalendarWithDots: UIViewRepresentable {
    let allEvents: [CalendarEvent]
    @Binding var selectedDate: Date
    let themeColor: Color

    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.calendar = Calendar.current
        calendarView.locale = Locale.current
        calendarView.fontDesign = .rounded
        
        // Setup selection behavior
        let selection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        calendarView.selectionBehavior = selection
        calendarView.delegate = context.coordinator
        
        return calendarView
    }

    func updateUIView(_ uiView: UICalendarView, context: Context) {
        //Get the components for the date you just changed
        let components = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        
        // 2. Tell the calendar to specifically reload that day (and any others if needed)
        uiView.reloadDecorations(forDateComponents: [components], animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarWithDots

        init(_ parent: CalendarWithDots) {
            self.parent = parent
        }

        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            let calendar = Calendar.current
            
            // Convert the dateComponents from the calendar into an actual Date object
            // to check the weekday
            guard let date = calendar.date(from: dateComponents) else { return nil }
            let weekday = calendar.component(.weekday, from: date)

            let hasEvent = parent.allEvents.contains { event in
                
                let isSameDay = calendar.isDate(event.timestamp, inSameDayAs: date)
                
               
                let isRepeatDay = event.repeatDays.contains(weekday)
                
                return isSameDay || isRepeatDay
            }

            if hasEvent {
                return .default(color: UIColor(parent.themeColor), size: .medium)
            }
            return nil
        }
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            if let date = dateComponents?.date {
                parent.selectedDate = date
            }
        }
    }
}

