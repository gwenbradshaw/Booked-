// new split screen

import SwiftUI
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

