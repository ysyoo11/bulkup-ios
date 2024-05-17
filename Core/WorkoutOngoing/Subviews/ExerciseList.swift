//
//  ExerciseList.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 17/5/2024.
//

import SwiftUI

struct ExerciseList: View {
    
    //@State var isChecked: Bool = false
    @Binding var isActiveRestTimerView: Bool
    let id: String
    let name: String
    let sets: [WorkoutSet]
    let autoRestTimer: Int?
    let onRemove: () -> Void
    let onAddSet: () -> Void
    let weight: Double = 0
    let reps: Int = 0
    let exerciseIndex: Int
    
    @State private var isActiveRemoveExerciseDialog: Bool = false
    
    var updateCompletedExercises: @MainActor (Int, WorkoutSet, Bool, Int) -> ()
    
    var body: some View {
        ZStack{
            VStack (spacing: 0){
                HStack {
                    Button {
                        print("Open exercise instructions etc")
                    } label: {
                        Text(name)
                            .font(Font.system(size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(.primaryBlue)
                            .underline()
                    }
                    Spacer()
                    OngoingExerciseMenu(onRemove: onRemove)
                }
                .padding()
                
                HStack {
                    Text("Set")
                        .font(Font.system(size: 15))
                        .fontWeight(.bold)
                    Spacer()
                    Text("Previous")
                        .font(Font.system(size: 15))
                        .fontWeight(.bold)
                    Spacer()
                    Text("kg")
                        .font(Font.system(size: 15))
                        .fontWeight(.bold)
                    Spacer()
                    Text("Reps")
                        .font(Font.system(size: 15))
                        .fontWeight(.bold)
                    Spacer()
                    Text("✔︎")
                        .font(Font.system(size: 15))
                        .fontWeight(.bold)
                }
                .padding(.bottom)
                .padding(.horizontal)
                
                ForEach(Array(sets.enumerated()), id: \.offset) { offset, set in
                    WorkoutOngoingSetList(
                        exerciseIndex: exerciseIndex,
                        set: offset + 1,
                        weight: set.weight ?? 0,
                        reps: set.reps,
                        isActiveRestTimerView: $isActiveRestTimerView,
                        weightStr: String(set.weight ?? 0),
                        repsStr: String(set.reps),
                        autoRestTimer: autoRestTimer ?? 0,
                        updateCompletedExercises: updateCompletedExercises)
                }
                
                BulkUpButton(
                    text: "+ Add Set",
                    color: .gray,
                    isDisabled: false,
                    isFullWidth: true,
                    onClick: { onAddSet() }
                )
                .padding(.horizontal)
            }
            if isActiveRemoveExerciseDialog {
                BulkUpDialog(
                    isActive: $isActiveRemoveExerciseDialog,
                    title: "Remove Exercise?",
                    message: "This removes",
                    actionButtonTitle: "Cancel",
                    action: {
                        onRemove()
                        isActiveRemoveExerciseDialog = false },
                    cancelButtonTitle: "Remove",
                    onClose: { isActiveRemoveExerciseDialog = false })
            }
        }
    }
}
