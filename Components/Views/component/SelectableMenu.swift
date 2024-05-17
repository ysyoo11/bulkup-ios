//
//  SelectableMenu.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 16/5/2024.
//

import SwiftUI

struct SelectableMenu: View {
    
    @Binding var currentlySelected: String
    var defaultDisplayValue: String
    var options: [String]
    var onChange: () -> Void
    
    var body: some View {
        Menu {
            Picker("", selection: $currentlySelected) {
                Text(defaultDisplayValue).tag("")
                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
            .onChange(of: currentlySelected, initial: false, {
                onChange()
            })
        } label: {
            BulkUpButton(text: currentlySelected.isEmpty ? defaultDisplayValue : currentlySelected,
                         color: !currentlySelected.isEmpty ? .blue : .gray,
                         isDisabled: false,
                         isFullWidth: true) {}
        }
    }
}
