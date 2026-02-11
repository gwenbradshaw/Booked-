//
//  Enums.swift
//  Booked!
//
//  Created by gwen bradshaw on 2/5/26.
//
import Foundation
import SwiftUI

enum AppMode: String, CaseIterable {
    case personal = "Personal"
    case school = "School"
    case work = "Work"
    
    var themeColor: Color {
        switch self{
        case .personal: return .green
        case .school: return .blue
        case .work: return .red
        }
    }
}
