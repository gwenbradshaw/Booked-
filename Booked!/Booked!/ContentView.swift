
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




