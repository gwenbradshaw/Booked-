
import SwiftUI

struct ContentView: View {
    //saving selection to phone memory
    @AppStorage("userRole") var userRole: String = "None"
    //using enum
    @State private var activeMode: AppMode? = nil
    

    var body: some View {
        if userRole == "None" {
            OnboardingView(selectedRole: $userRole)
        } else if activeMode == nil && userRole != "Human" {
            //split screen
            SplitSelectionView(role: userRole, activeMode: $activeMode, userRole: $userRole)
        } else {
            //show main app once selection has been made
            MainAppView(role: userRole, mode: activeMode ?? .personal, activeMode: $activeMode)
        }

    }

}
//the pop up options/screen for one time use when you set up app
struct OnboardingView: View {
    @Binding var selectedRole: String
    var body: some View{
        VStack(spacing: 20){
            Text("Welcome to Booked!")
            .font(.largeTitle)
            .bold()

            Button("I'm a Student 🎓"){ selectedRole = "Student"}
            .buttonStyle(.borderedProminent)

            Button ("I'm working 💼"){ selectedRole = "Worker"}
            .buttonStyle(.borderedProminent)

            Button("Neither😛") {selectedRole = "Human"}
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
// new split screen
struct SplitSelectionView: View{
    let role: String
    @Binding var activeMode: AppMode?
    @Binding var userRole: String
    
    var body: some View{
        VStack(spacing:0){
            Text ("BOOKED!")
                .font(.system(size: 40, weight: .black))
                .padding(.vertical, 40)
            
            HStack(spacing: 0){
                //left side (either SCHOOL or WORK)
                let leftMode: AppMode = (role == "Student" ? .school : .work)
                Button(action: { activeMode = leftMode }) {
                    VStack(spacing: 15) {
                        Image(systemName: role == "Student" ? "graduationcap.fill" : "briefcase.fill")
                            .font(.system(size: 50))
                        Text(leftMode.rawValue)
                            .font(.title2).bold()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    //theme color
                    .background(leftMode.themeColor.opacity(0.2))
                    .foregroundColor(leftMode.themeColor)
                }
                //Right side (personal)
                Button(action: { activeMode = .personal}) {
                    VStack (spacing: 15) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 50))
                        Text(AppMode.personal.rawValue)
                            .font(.title2).bold()
                    }
                    .frame(maxWidth: .infinity, maxHeight:  .infinity)
                    .background(AppMode.personal.themeColor.opacity(0.2))
                    .foregroundColor(AppMode.personal.themeColor)
                }
            }
            .padding(.bottom, 30)
            
            //back button
            Button(action: { userRole = "None" } ) {
                Text("Back").font(.footnote).foregroundColor(.secondary)
            }
            .padding()
        }
        .ignoresSafeArea(edges: .bottom)
    }
}


// screen for student, worker, human for the tabs there
struct MainAppView: View {
    let role: String
    let mode: AppMode
    @AppStorage("userRole") var userRole: String = "None"
    @Binding var activeMode: AppMode?
    
    // /(role) is how you make a variable
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View{
        VStack{
            Text(mode.rawValue.uppercased())
                .font(.system(size:40, weight: .black))
                .foregroundColor(mode.themeColor)
                .padding(.top)

                Divider()

                //grid layout
                LazyVGrid(columns: columns, spacing:30){
                    DashboardItem(icon: "calendar", label: "Calendar", color: mode.themeColor)
                    DashboardItem(icon: "doc.text", label: mode == .personal ? "Notes" : "Assignments", color: mode.themeColor)
                    DashboardItem(icon: "checklist", label: "To-Do's", color: mode.themeColor)
                }
                .padding()

                Spacer()
            
            Button(action: { activeMode = nil }) {
                Label("Switch Side", systemImage: "arrow.left.arrow.rigt")
            }
            .padding()
            .buttonStyle(.bordered)
                

            
                }
            }
        }
      
struct DashboardItem: View {
    let icon: String
    let label: String
    let color: Color

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(color, lineWidth: 2)
                .frame(width: 80, height: 80)
                .overlay(Image(systemName: icon).font(.largeTitle).foregroundColor(color))
            
            Text(label)
                .font(.caption)
                .bold()
        }
    }
}
