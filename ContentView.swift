ContentView.swift
import SwiftUI

struct ContentView: View {
    //saving selection to phone memory
    @AppStorage("userRole") var userRole: String = "None"

    var body: some View {
        if userRole == "None"{
            OnboardingView(selectedRole: $userRole)
        } else{
            //show main app once selection has been made
            MainAppView(role: userRole)
        }

    }

}
//the pop up options/screen
strict OnboardingView: View {
    @Binding var selectedRole: String
    var body: some View{
        VStack(spacing: 20){
            Text("Welcome to Booked!")
            .font(.largeTitle)
            .bold()

            Text("To get started, tell us a bit more about yourself:")
            .multilineTextAlignment(.center)
            .badding()

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
struct MainAppVeiw: View{
    let role: String
    // /(role) is how you make a variable 
    
    var body: some View{
        VStack{
            Text ("Hi, \(role)!")
                .font(.title)
            Text("Here is your Booked! dashboard.")
        }
    }
    Button ("Logout") {
        UserDefaults.standard.set("None", forKey: "userRole")
    }
    .padding(.top)
    .foregroundColor(.red)
}