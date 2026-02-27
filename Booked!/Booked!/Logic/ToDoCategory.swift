//
//  ToDoCategory.swift
//  Booked!
//
//  Created by gwen bradshaw on 2/26/26.
//
import SwiftUI
struct TodoCategory: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var icon: String // names for categories
}
