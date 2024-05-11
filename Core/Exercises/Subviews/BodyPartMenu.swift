//
//  BodyPartMenu.swift
//  BulkUp
//
//  Created by Yuta Horiuchi on 9/5/2024.
//

import SwiftUI

struct BodyPartMenu: View {
    
    let allBodyParts = BodyPart.allCases.map { $0.rawValue }
    @State var currentlySelected: String = ""
    
    var body: some View {
        Menu {
            Picker("", selection: $currentlySelected) {
                Text("Any Body Part").tag("")
                ForEach(allBodyParts, id: \.self) { bodyPart in
                    Text(bodyPart)
                }
            }
        } label: {
            BulkUpButton(text: currentlySelected.isEmpty ? "Any Body Part" : "\(currentlySelected)",
                         color: !currentlySelected.isEmpty ? .blue : .gray,
                         isDisabled: false, isFullWidth: true) {}
        }
    }
}

#Preview {
    BodyPartMenu()
}
