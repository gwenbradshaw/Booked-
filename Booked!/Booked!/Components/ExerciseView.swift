//
//  ExerciseView.swift
//  Booked!
//
//  Created by gwen bradshaw on 4/6/26.
//
import SwiftUI

struct ExerciseView: View {
    @Binding var exercise: Exercise
    var isEditing: Bool
    var onDelete: () -> Void
    var onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if isEditing {
                    Button(role: .destructive, action: onDelete) {
                        Image(systemName: "minus.circle.fill")
                    }
                }
                
                TextField("Exercise Name", text: $exercise.name)
                    .font(.system(.headline, design: .rounded))
                    .onChange(of: exercise.name) { _ in onSave() }
                
                Spacer()
                
                Button(action: addSet) {
                    Label("Add Set", systemImage: "plus")
                        .font(.caption.bold())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(8)
                }
            }

            // Column Headers
            HStack(spacing: 15) {
                Text("SET").frame(width: 35, alignment: .leading)
                Text("LBS").frame(maxWidth: .infinity)
                Text("REPS").frame(maxWidth: .infinity)
                Spacer().frame(width: 35)
            }
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.secondary)

            ForEach($exercise.sets) { $set in
                SetRowView(
                    set: $set,
                    setNumber: (exercise.sets.firstIndex(where: { $0.id == set.id }) ?? 0) + 1,
                    onSave: onSave
                )
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 18).fill(Color.purple.opacity(0.05)))
    }

    func addSet() {
        let lastSet = exercise.sets.last
        let newSet = WorkoutSet(weight: lastSet?.weight ?? "", reps: lastSet?.reps ?? "")
        exercise.sets.append(newSet)
        onSave()
    }
}
