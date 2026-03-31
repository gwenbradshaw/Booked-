import SwiftUI
import UserNotifications

struct MainAppView: View {
    let role: String
    let mode: AppMode
    @State private var showingCalendar = false
    @State private var showingAddEvent = false
    @AppStorage("userRole") var userRole: String = "None"
    @Binding var activeMode: AppMode?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 1. HEADER
                Text(mode.rawValue.uppercased())
                    .font(.system(size: 40, weight: .black))
                    .foregroundColor(mode.themeColor)
                    .padding(.top)
                
                Divider()
                    .padding(.vertical, 20)
                
 
                VStack(spacing: 18) {
                    
                    // CALENDAR
                    Button(action: { showingCalendar = true }) {
                        HStack {
                            Image(systemName: "calendar")
                            Text("Calendar")
                                .fontWeight(.bold)
                        }
                        .modifier(RectangleStyle(color: mode.themeColor))
                    }
 
                    //Assignments/tasks

                    // Assignments (School Only)
                    if mode == .school {
                        NavigationLink(destination: SchoolClassDashboard()) {
                            HStack {
                                Image(systemName: "graduationcap.fill")
                                Text("Assignments")
                                    .fontWeight(.bold)
                            }
                            .modifier(RectangleStyle(color: mode.themeColor))
                        }
                    }

                    // Tasks (Work Only)
                    else if mode == .work {
                        NavigationLink(destination: WorkDashboard()) {
                            HStack {
                                Image(systemName: "briefcase.fill")
                                Text("Tasks")
                                    .fontWeight(.bold)
                            }
                            .modifier(RectangleStyle(color: mode.themeColor))
                        }
                    }

                    // 3. To-Do's (Visible in both)
                    NavigationLink(destination: To_DoView()) {
                        HStack {
                            Image(systemName: "checklist")
                            Text("To-Do's")
                                .fontWeight(.bold)
                        }
                        .modifier(RectangleStyle(color: mode.themeColor))
                    }
                    

                    //EVENTS
                    NavigationLink(destination: Text("Events Screen")) {
                        HStack {
                            Image(systemName: "sparkles") // "sparkles" or "calendar.badge.plus"
                            Text("Events")
                                .fontWeight(.bold)
                        }
                        .modifier(RectangleStyle(color: mode.themeColor))
                    }
           
                    // NOTES
                    NavigationLink(destination: NotesView()) {
                        HStack {
                            Image(systemName: "doc.text")
                            Text("Notes")
                                .fontWeight(.bold)
                        }
                        .modifier(RectangleStyle(color: mode.themeColor))
                    }
                }

                }
                .padding(.horizontal, 20)
                
                Spacer()
                // 3. BOTTOM SWITCH BUTTON
                Button(action: { activeMode = nil }) {
                    Label("Switch Side", systemImage: "arrow.left.arrow.right")
                        .fontWeight(.semibold)
                }
                .padding()
                .buttonStyle(.bordered)
                .tint(mode.themeColor)
            }
            .sheet(isPresented: $showingCalendar) {
                CalendarView(mode: mode)
            }
        }
    }


struct RectangleStyle: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)
            .background(Color.white)
            .foregroundColor(color)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color, lineWidth: 2)
            )
    }
}
