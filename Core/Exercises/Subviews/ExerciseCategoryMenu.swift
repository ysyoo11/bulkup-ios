//
//  ExerciseCategoryMenu.swift
//  BulkUp
//
//  Created by Yuta Horiuchi on 9/5/2024.
//

import SwiftUI

struct ExerciseCategoryMenu: View {
    
    let allCategories = ExerciseCategory.allCases.map { $0.rawValue }
    @State var currentlySelected: String = ""
    
    var body: some View {
        Menu {
            Picker("", selection: $currentlySelected) {
                Text("Any Category").tag("")
                ForEach(allCategories, id: \.self) { category in
                    Text(category)
                }
            }
        } label: {
            BulkUpButton(text: currentlySelected.isEmpty ? "Any Category" : "\(currentlySelected)",
                         color: !currentlySelected.isEmpty ? .blue : .gray,
                         isDisabled: false,
                         isFullWidth: true) {}
        }
    }
}

#Preview {
    ExerciseCategoryMenu()
}
