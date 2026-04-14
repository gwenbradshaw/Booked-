//
//  EventModel.swift
//  Booked!
//
//  Created by gwen bradshaw on 2/12/26.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class CalendarEvent {
    var title: String
    var timestamp: Date
    var eventType: String
    var stateGroup: String
    var isCompleted: Bool = false
    var repeatDays: [Int] = []
    
    // Category for the "Special Events" logic
    var categoryName: String?
    var categoryColor: String?
    
    init(title: String = "",
         timestamp: Date = .now,
         eventType: String = "Task",
         stateGroup: String = "Personal",
         isCompleted: Bool = false,
         repeatDays: [Int] = [],
         categoryName: String? = nil,
         categoryColor: String? = nil) {
        
        self.title = title
        self.timestamp = timestamp
        self.eventType = eventType
        self.stateGroup = stateGroup
        self.isCompleted = isCompleted
        self.repeatDays = repeatDays
        self.categoryName = categoryName
        self.categoryColor = categoryColor
    }
}

    
