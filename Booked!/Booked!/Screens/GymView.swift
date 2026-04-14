//
//  GymView.swift
//  Booked!
//
//  Created by gwen bradshaw on 2/27/26.
//
import SwiftUI

struct GymView: View {
    @AppStorage("gym_workouts_json") private var workoutsData: String = "[]"
    @State private var showingAddWorkout = false

    var workouts: [Workout] {
        GymLogic.decodeWorkouts(workoutsData)
    }

    var body: some View {
        // Switching to List makes swipeActions 100% reliable
        List {
            if workouts.isEmpty {
                emptyStatePlaceholder
            } else {
                ForEach(workouts) { workout in
                    workoutRow(for: workout)
                        .listRowSeparator(.hidden) // Removes the gray lines
                        .listRowBackground(Color.clear) // Removes the white row block
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteWorkout(workout)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .listStyle(.plain) // Keeps it clean and edge-to-edge
        .navigationTitle("Gym")
        .toolbar {
            Button { showingAddWorkout = true } label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.purple)
            }
        }
        .sheet(isPresented: $showingAddWorkout) {
            AddWorkoutSheet(workoutsData: $workoutsData)
        }
    }

    // --- Subviews to keep code clean ---
    
    @ViewBuilder
    func workoutRow(for workout: Workout) -> some View {
        NavigationLink(destination: WorkoutDetailView(workout: workout)) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(0.12))
                        .frame(width: 52, height: 52)
                    Image(systemName: "figure.run")
                        .foregroundColor(.purple)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.title)
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.primary)
                    Text("\(workout.exercises.count) exercises")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.purple.opacity(0.06)))
        }
        .buttonStyle(.plain) // Prevents the whole row from turning gray when tapped
    }

    var emptyStatePlaceholder: some View {
        VStack(spacing: 15) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 60))
                .foregroundColor(.purple.opacity(0.2))
            Text("No splits created yet.")
                .font(.system(.headline, design: .rounded))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 100)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }

    func deleteWorkout(_ workout: Workout) {
        var currentList = GymLogic.decodeWorkouts(workoutsData)
        currentList.removeAll { $0.id == workout.id }
        workoutsData = GymLogic.encodeWorkouts(currentList)
    }
}
