//
//  HistoryEditMenu.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 6/5/2024.
//

import SwiftUI

let historyEditMenuOptions: [MenuContent] = [
    .option(text: "Delete", icon: "xmark", action: {
        print("Delete tapped")
    }),
    .option(text: "Edit Workout", icon: "pencil", action: {
        print("Edit Workout tapped")
    })
]

struct HistoryEditMenu: View {
    var body: some View {
        BulkUpMenu(options: historyEditMenuOptions)
    }
}

#Preview {
    HistoryEditMenu()
}
