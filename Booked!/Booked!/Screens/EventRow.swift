//
//  EventRow.swift
//  Booked!
//
//  Created by gwen bradshaw on 4/13/26.
//
import SwiftUI
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
struct EventRow: View {
    let event: CalendarEvent
    
    var body: some View {
        HStack(spacing: 15) {
            // Safe color extraction
            let accentColor = Color(hex: event.categoryColor ?? "#D1D1D1")
            
            RoundedRectangle(cornerRadius: 2)
                .fill(accentColor)
                .frame(width: 4)
                .padding(.vertical, 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.system(.headline, design: .rounded))
                
                Text(event.timestamp.formatted(.dateTime.day().month(.wide)))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if let name = event.categoryName {
                Text(name)
                    .font(.system(size: 10, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(accentColor.opacity(0.2))
                    .foregroundColor(accentColor)
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity) // Ensure it fills the width
        .frame(height: 60)
        .background(Color.white.opacity(0.8)) // Slightly more solid for stability
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
