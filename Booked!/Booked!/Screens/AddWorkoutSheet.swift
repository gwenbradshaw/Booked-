//
//  AddWorkoutSheet.swift
//  Booked!
//
//  Created by gwen bradshaw on 2/27/26.
//
import SwiftUI


struct AddWorkoutSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var workoutsData: String
    
    @State private var workoutTitle = ""
    @State private var exerciseName = ""
    @State private var tempExercises: [Exercise] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header Section
                    VStack(alignment: .leading) {
                        Text("Split Name")
                            .font(.caption).bold().foregroundColor(.secondary)
                        TextField("e.g. Upper Body, Legs...", text: $workoutTitle)
                            .padding()
                            .background(Color.white.cornerRadius(12))
                    }
                    .padding(.horizontal)
                    
                    // Add Exercise Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Add Exercises")
                            .font(.caption).bold().foregroundColor(.secondary)
                        
                        HStack {
                            TextField("Exercise name...", text: $exerciseName)
                                .padding()
                                .background(Color.white.cornerRadius(12))
                            
                            Button(action: addExercise) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.green.opacity(0.7))
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // List of added exercises
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(tempExercises) { ex in
                                HStack {
                                    Text(ex.name)
                                        .font(.subheadline).bold()
                                    Spacer()
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green.opacity(0.5))
                                }
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // Save Button
                    Button(action: saveWorkout) {
                        Text("Create Split")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(workoutTitle.isEmpty || tempExercises.isEmpty ? Color.gray : Color.purple.opacity(0.7))
                            .cornerRadius(15)
                    }
                    .disabled(workoutTitle.isEmpty || tempExercises.isEmpty)
                    .padding()
                }
                .padding(.top)
            }
            .navigationTitle("New Split")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    func addExercise() {
        let trimmed = exerciseName.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty {
            // We now initialize with one empty WorkoutSet
            let firstSet = WorkoutSet(weight: "", reps: "")
            let newEx = Exercise(name: trimmed, sets: [firstSet])
            
            tempExercises.append(newEx)
            exerciseName = ""
        }
    }
    func saveWorkout() {
        var currentWorkouts = GymLogic.decodeWorkouts(workoutsData)
        let newWorkout = Workout(title: workoutTitle, exercises: tempExercises)
        currentWorkouts.append(newWorkout)
        workoutsData = GymLogic.encodeWorkouts(currentWorkouts)
        dismiss()
    }
}
