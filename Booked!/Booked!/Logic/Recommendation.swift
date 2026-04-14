//
//  Recommendation.swift
//  Booked!
//
//  Created by gwen bradshaw on 4/7/26.
//
import Foundation

enum RecCategory: String, CaseIterable, Codable, Identifiable {
    case movie = "Movie"
    case show = "TV Show"
    case book = "Book"
    case restaurant = "Restaurant"
    
    var id: String { self.rawValue }
    var icon: String {
        switch self {
        case .movie: return "popcorn.fill"
        case .show: return "tv.fill"
        case .book: return "book.closed.fill"
        case .restaurant: return "fork.knife"
        }
    }
}

struct Recommendation: Identifiable, Codable {
    var id = UUID()
    var title: String
    var note: String
    var category: RecCategory
    var isDone: Bool = false
}

