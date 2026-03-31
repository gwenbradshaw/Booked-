//
//  TaskModel.swift
//  Booked!
//
//  Created by gwen bradshaw on 3/30/26.
//
import Foundation
//for the task manager in assignments and work tasks
struct UniversalTask: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var status: String
    var dueDate: Date = Date()
    var className: String = ""
    var isCompleted: Bool = false // Add this
}

