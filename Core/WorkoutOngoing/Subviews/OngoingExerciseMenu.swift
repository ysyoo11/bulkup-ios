//
//  OngoingExerciseMenu.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 6/5/2024.
//

import SwiftUI

struct OngoingExerciseMenu: View {
    
    let onRemove: () -> Void

    var body: some View {
        BulkUpMenu(options: [
            .option(text: "Remove Exercise", icon: "xmark", action: onRemove)
        ])
    }
}

#Preview {
    OngoingExerciseMenu(onRemove: { print("Remove Exercise") })
}
