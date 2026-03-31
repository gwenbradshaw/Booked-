import SwiftUI

struct ContentView: View {
    @AppStorage("userRole") var userRole: String = "None"
    @State private var activeMode: AppMode? = nil

    var body: some View {
        // User Group
        Group {
            if userRole == "None" {
                OnboardingView(selectedRole: $userRole)
            } else if activeMode == nil {
                SplitSelectionView(role: userRole, activeMode: $activeMode, userRole: $userRole)
            } else {
                MainAppView(role: userRole, mode: activeMode!, activeMode: $activeMode)
            }
        }
    }
}
