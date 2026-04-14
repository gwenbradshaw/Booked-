//
//  WorkoutDetailView.swift
//  Booked!
//
//  Created by gwen bradshaw on 2/27/26.
//

import SwiftUI
struct WorkoutDetailView: View {
    let workout: Workout
    @AppStorage("gym_workouts_json") private var workoutsData: String = "[]"
    @State private var exercises: [Exercise] = []
    @State private var isEditingLayout = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach($exercises) { $exercise in
                    ExerciseView(
                        exercise: $exercise,
                        isEditing: isEditingLayout,
                        onDelete: { deleteExercise(exercise) },
                        onSave: saveChanges
                    )
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(workout.title)
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .toolbar {
            Button(isEditingLayout ? "Done" : "Edit") {
                withAnimation { isEditingLayout.toggle() }
            }
        }
        .onAppear { loadInitialData() }
    }

    func loadInitialData() {
        let all = GymLogic.decodeWorkouts(workoutsData)
        if let found = all.first(where: { $0.id == workout.id }) {
            self.exercises = found.exercises
        }
    }

    func deleteExercise(_ exercise: Exercise) {
        exercises.removeAll { $0.id == exercise.id }
        saveChanges()
    }

    func saveChanges() {
        var allWorkouts = GymLogic.decodeWorkouts(workoutsData)
        if let index = allWorkouts.firstIndex(where: { $0.id == workout.id }) {
            allWorkouts[index].exercises = exercises
            workoutsData = GymLogic.encodeWorkouts(allWorkouts)
        }
    }
}
