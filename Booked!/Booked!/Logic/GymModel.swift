//
//  GymModel.swift
//  Booked!
//
//  Created by gwen bradshaw on 4/2/26.
//
import Foundation


struct WorkoutSet: Identifiable, Codable {
    var id = UUID()
    var weight: String
    var reps: String
    var isCompleted: Bool = false // check-off function
}

struct Exercise: Identifiable, Codable {
    var id = UUID()
    var name: String
    var sets: [WorkoutSet]
}

struct Workout: Identifiable, Codable {
    var id = UUID()
    var title: String
    var exercises: [Exercise]
}


struct GymLogic {
    static func decodeWorkouts(_ json: String) -> [Workout] {
        guard let data = json.data(using: .utf8) else { return [] }
        return (try? JSONDecoder().decode([Workout].self, from: data)) ?? []
    }
    
    static func encodeWorkouts(_ workouts: [Workout]) -> String {
        guard let data = try? JSONEncoder().encode(workouts) else { return "[]" }
        return String(data: data, encoding: .utf8) ?? "[]"
    }
}
