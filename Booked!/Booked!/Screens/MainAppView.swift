// screen for student, worker, human for the tabs there

import SwiftUI
struct MainAppView: View {
    let role: String
    let mode: AppMode
    @State private var showingCalendar = false
    @State private var showingAddEvent = false
    @AppStorage("userRole") var userRole: String = "None"
    @Binding var activeMode: AppMode?
    
    // /(role) is how you make a variable
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(mode.rawValue.uppercased())
                    .font(.system(size: 40, weight: .black))
                    .foregroundColor(mode.themeColor)
                    .padding(.top)
                
                Divider()
                
                // Grid layout
                LazyVGrid(columns: columns, spacing: 30) {
                    
                    // 1. NOTES / ASSIGNMENTS
                    NavigationLink(destination: NotesView()) {
                        DashboardItem(icon: "doc.text", label: mode == .personal ? "Notes" : "Assignments", color: mode.themeColor)
                    }
                    
                    // 2. TO-DO'S: Tapping this will now open your To_DoView
                    NavigationLink(destination: To_DoView()) {
                        DashboardItem(icon: "checklist", label: "To-Do's", color: mode.themeColor)
                    }
                    
                    // 3. CALENDAR
                    Button(action: { showingCalendar = true }) {
                        DashboardItem(icon: "calendar", label: "Calendar", color: mode.themeColor)
                    }
                }
                .padding()
                
                Spacer()
                
                Button(action: { activeMode = nil }) {
                    Label("Switch Side", systemImage: "arrow.left.arrow.right")
                }
                .padding()
                .buttonStyle(.bordered)
            }
            .sheet(isPresented: $showingCalendar) {
                CalendarView(mode: mode)
            }
        }
    }
}
