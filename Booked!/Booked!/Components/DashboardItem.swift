import SwiftUI
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

