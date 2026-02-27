//
//  AddWorkoutSheet.swift
//  Booked!
//
//  Created by gwen bradshaw on 2/27/26.
//
import SwiftUI
struct AddWorkoutSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var savedWorkouts: String
    @State private var title = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Workout Title (e.g. Leg Day)", text: $title)
            }
            .navigationTitle("New Workout")
            .toolbar {
                Button("Save") {
                    savedWorkouts += (savedWorkouts.isEmpty ? "" : "|") + title
                    dismiss()
                }
            }
        }
    }
}
