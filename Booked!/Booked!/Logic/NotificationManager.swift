//
//  NotificationManager.swift
//  Booked!
//
//  Created by gwen bradshaw on 3/17/26.
//
import UserNotifications

class NotificationManager {
    static let instance = NotificationManager()
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Permissions granted!")
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
        func cancelNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        
        let repeatingIDs = (1...7).map { "\(id)-\($0)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: repeatingIDs)
    }
    
    func scheduleNotification(title: String, date: Date, repeatDays: [Int], id: String, offsetMinutes: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = .default
        

        guard let triggerDate = Calendar.current.date(byAdding: .minute, value: -offsetMinutes, to: date) else { return }
        print("DEBUG: notification scheduled for: \(triggerDate.formatted())")
        
        let calendar = Calendar.current
        
        if repeatDays.isEmpty {
            
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        } else {
            for day in repeatDays {
                
                var components = calendar.dateComponents([.hour, .minute], from: triggerDate)
                components.weekday = day
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                let request = UNNotificationRequest(identifier: "\(id)-\(day)", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}

