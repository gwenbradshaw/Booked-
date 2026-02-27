//
//  WorkoutDetailView.swift
//  Booked!
//
//  Created by gwen bradshaw on 2/27/26.
//

import SwiftUI

struct WorkoutDetailView: View {
    let workoutTitle: String
    @AppStorage("workout_items_") private var allExercises: String = "" // In a real app, we'd use a unique ID here
    @State private var newExercise = ""

    var body: some View {
        List {
            // Filter exercises that belong to THIS specific workout
            let exerciseList = allExercises.components(separatedBy: "|").filter { $0.contains(workoutTitle) }
            
            ForEach(exerciseList, id: \.self) { item in
                let cleanName = item.replacingOccurrences(of: "\(workoutTitle):", with: "")
                Text(cleanName)
            }
            
            TextField("Add exercise (e.g. 3x10 Squats)", text: $newExercise)
                .onSubmit {
                    if !newExercise.isEmpty {
                        allExercises += (allExercises.isEmpty ? "" : "|") + "\(workoutTitle):\(newExercise)"
                        newExercise = ""
                    }
                }
        }
        .navigationTitle(workoutTitle)
    }
}
