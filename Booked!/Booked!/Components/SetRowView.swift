//
//  SetRowView.swift
//  Booked!
//
//  Created by gwen bradshaw on 4/6/26.
//
import SwiftUI

struct SetRowView: View {
    @Binding var set: WorkoutSet
    let setNumber: Int
    var onSave: () -> Void

    var body: some View {
        HStack(spacing: 15) {
            Text("\(setNumber)")
                .font(.system(.subheadline, design: .monospaced)).bold()
                .frame(width: 35)
                .foregroundColor(set.isCompleted ? .white : .primary)
                .padding(.vertical, 4)
                .background(set.isCompleted ? Color.green : Color.clear)
                .cornerRadius(6)

            TextField("0", text: $set.weight)
                .keyboardType(.decimalPad)
                .textFieldStyle(.plain)
                .padding(8)
                .background(set.isCompleted ? Color.green.opacity(0.1) : Color.white)
                .cornerRadius(8)
                .multilineTextAlignment(.center)
                .onChange(of: set.weight) { _ in onSave() }

            TextField("0", text: $set.reps)
                .keyboardType(.numberPad)
                .textFieldStyle(.plain)
                .padding(8)
                .background(set.isCompleted ? Color.green.opacity(0.1) : Color.white)
                .cornerRadius(8)
                .multilineTextAlignment(.center)
                .onChange(of: set.reps) { _ in onSave() }

            Button {
                withAnimation(.spring(response: 0.3)) { set.isCompleted.toggle() }
                onSave()
            } label: {
                Image(systemName: set.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(set.isCompleted ? .green : .gray.opacity(0.3))
            }
            .frame(width: 35)
        }
    }
}
