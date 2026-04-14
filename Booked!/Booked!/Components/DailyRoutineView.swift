//
//  DailyRoutineView.swift
//  Booked!
//
//  Created by gwen bradshaw on 4/7/26.
//

import SwiftUI

struct DailyRoutineView: View {
    let title: String
    @AppStorage private var savedRoutine: String

    init(title: String) {
        self.title = title
        self._savedRoutine = AppStorage(wrappedValue: "", "routine_\(title)")
    }

    var body: some View {
        List {
            Section("My Timeline") {
                let items = savedRoutine.components(separatedBy: "|").filter { !$0.isEmpty }
                ForEach(items, id: \.self) { item in
                    let parts = item.components(separatedBy: ":")
                    HStack {
                        Text(parts.first ?? "").bold().frame(width: 80, alignment: .leading)
                        Text(parts.last ?? "")
                    }
                }
            }
            // Add inputs for Time and Task here
        }
        .navigationTitle(title)
    }
}
