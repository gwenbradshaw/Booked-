//
//  GymView.swift
//  Booked!
//
//  Created by gwen bradshaw on 2/27/26.
//
import SwiftUI

struct GymView: View {
    @AppStorage("saved_workouts") private var savedWorkouts: String = ""
    @State private var showingAddWorkout = false
    
    var body: some View {
        List {
            let workoutTitles = savedWorkouts.components(separatedBy: "|").filter { !$0.isEmpty }
            
            ForEach(workoutTitles, id: \.self) { title in
                NavigationLink(destination: WorkoutDetailView(workoutTitle: title)) {
                    Label(title, systemImage: "figure.strengthtraining.traditional")
                }
            }
        }
        .navigationTitle("Workouts")
        .toolbar {
            Button { showingAddWorkout = true } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddWorkout) {
            AddWorkoutSheet(savedWorkouts: $savedWorkouts)
        }
    }
}
