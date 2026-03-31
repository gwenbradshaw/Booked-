//the pop up options/screen for one time use when you set up app

import SwiftUI
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

            Button("Neither") {selectedRole = "Human"}
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

