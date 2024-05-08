//
//  OngoingExerciseMenu.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 6/5/2024.
//

import SwiftUI

let ongoingExerciseMenuOptions: [MenuContent] = [
    .option(text: "Remove Exercise", icon: "xmark", action: {
        print("Remove Exercise tapped")
    }),
    .navigationOption(text: "Auto Rest Timer", icon: "timer", destination: AnyView(RestTimerSetupView()))
]

struct OngoingExerciseMenu: View {
    var body: some View {
        BulkUpMenu(options: ongoingExerciseMenuOptions)
    }
}

#Preview {
    OngoingExerciseMenu()
}
