//
//  RestTimerView.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 6/5/2024.
//

import SwiftUI

struct RestTimerSetupView: View {
    
    let minRestTime = 30
    let maxRestTime = 300
    
    @Binding var exerciseIndex: Int
    @Binding var exercise: UserTemplateExerciseWithExercise?
    @Binding var currentStagedExercises: [UserTemplateExerciseWithExercise]
    var setAutoRestTimer: @MainActor (Int, Int, [UserTemplateExerciseWithExercise]) -> ()
    var disableAutoRestTimer: @MainActor (Int, [UserTemplateExerciseWithExercise]) -> ()
    
    @State private var isEnabled = true
    @State var timer: Int = 90
    
    private func parseSecToStr(time: Int) -> String {
        let min = time / 60
        let secRemainder = time % 60
        let sec = secRemainder < 10 ? "0\(secRemainder)" : "\(secRemainder)"
        return "\(min):\(sec)"
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $isEnabled) {
                        Text("Enabled")
                    }
                    .onChange(of: isEnabled) { _, toggled in
                        if toggled {
                            setAutoRestTimer(exerciseIndex, timer, currentStagedExercises)
                        } else {
                            disableAutoRestTimer(exerciseIndex, currentStagedExercises)
                        }
                    }
                }
                .onAppear {
                    if exercise != nil && exercise?.autoRestTimerSec != nil {
                        isEnabled = true
                    }
                }

                Section(header: Text("Time Presets")) {
                    Picker("", selection: $timer){
                        ForEach(minRestTime...maxRestTime, id: \.self) { i in
                            if i % 10 == 0 {
                                Text(parseSecToStr(time: i)).tag(i)
                            }
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .disabled(!isEnabled)
                    .onChange(of: timer) { _, sec in
                        if isEnabled {
                            setAutoRestTimer(exerciseIndex, timer, currentStagedExercises)
                        }
                    }
                }
                .onAppear {
                    if exercise != nil && exercise?.autoRestTimerSec != nil {
                        timer = exercise!.autoRestTimerSec ?? 120
                    }
                }
                .opacity(isEnabled ? 1.0 : 0.4)
            }
            .navigationBarTitle("Auto Rest Timer")
        }
    }
}

//#Preview {
//    RestTimerSetupView(, exerciseIndex: <#Binding<Int>#>)
//}
