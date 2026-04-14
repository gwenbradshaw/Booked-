//
//  ToDoCategory.swift
//  Booked!
//
//  Created by gwen bradshaw on 2/26/26.
//
import SwiftUI

// 1. The Model for your lists
struct ToDoCategory: Identifiable, Codable {
    var id = UUID()
    var name: String
    var template: ListTemplate
}
