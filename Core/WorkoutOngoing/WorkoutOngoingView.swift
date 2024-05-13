//
//  WorkoutOngoingView.swift
//  BulkUp
//
//  Created by Yuta Horiuchi on 11/5/2024.
//

import SwiftUI

struct WorkoutOngoingView: View {
    
    @State private var isActiveRestTimerView: Bool = false
    @State private var isActiveAddExerciseView: Bool = false
    @State private var isActiveCancelWorkoutDialog: Bool = false
    @State private var isActiveFinishWorkoutDialog: Bool = false
    @EnvironmentObject var restTimerModel: CountDownTimerModel
    @EnvironmentObject var workOutTimerModel: CountUpTimerModel
    @EnvironmentObject var timerSettings: TimerSettings
    
    // Testing purpose
//    @State var selectedExercises: [Exercise] =
//            [Exercise(id: "1", name: "Squat", bodyPart: .legs, type: .barbell, description: "description...", imageUrl: "url"),
//            Exercise(id: "2", name: "Bench Press", bodyPart: .legs, type: .barbell, description: "description...",imageUrl: "url")
//            ]
    
//    func removeExercise(withID id: String) {
//        selectedExercises.removeAll { $0.id == id }
//    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack (alignment: .leading, spacing: 0) {
                        
                        
                        VStack (alignment: .leading, spacing: 0){
                            Text("Workout")
                                .font(Font.system(size: 25))
                                .fontWeight(.bold)
                            Text("\(workOutTimerModel.timerStringValue)")
                                .font(Font.system(size: 15))
                                .foregroundColor(.primaryGray)
                        }
                        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                            if workOutTimerModel.isStarted {
                                workOutTimerModel.updateTimer()
                            }
                        }
                        .padding()
                        
                        
                        // Populate Exercise List here
//                        ForEach(selectedExercises, id: \.id) { exercise in
//                            ExerciseList(isActiveRestTimerView: $isActiveRestTimerView, id: exercise.id, name: exercise.name, onRemove: {
//                                self.removeExercise(withID: exercise.id)
//                            })
//                        }
                        
                        VStack {
                            BulkUpButton(text: "Add Exercises", color: .skyblue, isDisabled: false, isFullWidth: true, onClick: { print("Add Exercises") })
                            BulkUpButton(text: "Cancel Workout", color: .pink, isDisabled: false, isFullWidth: true, onClick: { isActiveCancelWorkoutDialog = true })
                        }
                        .padding()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        SetListButton(text: restTimerModel.isStarted ? restTimerModel.timerStringValue : "Timer", foregroundColor: .primaryGray, backgroundColor: .secondaryGray, action: { isActiveRestTimerView = true })
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        SetListButton(text: "Finish", foregroundColor: .white, backgroundColor: .primaryGreen, action: { isActiveFinishWorkoutDialog = true})
                    }
                }
            }
            if isActiveRestTimerView {
                RestTimerView(isActive: $isActiveRestTimerView, duration: timerSettings.timer)
            }
            if isActiveAddExerciseView {
                //Open View to add exercise
            }
            if isActiveCancelWorkoutDialog {
                BulkUpDialog(isActive: $isActiveCancelWorkoutDialog, type: .alert, title: "Cancel Workout?", message: "Are you sure you want to cancel this workout? All progress will be lost.", actionButtonTitle: "Cancel Workout", action: { print("Close/Dispose WorkoutOngoingView") }, cancelButtonTitle: "Resume", onClose: { print("Resume workout") })
            }
            if isActiveFinishWorkoutDialog {
                BulkUpDialog(isActive: $isActiveFinishWorkoutDialog, type: .confirm, title: "🎉", message: "Finish Workout?", actionButtonTitle: "Finish", action: { print("Finish Workout") }, cancelButtonTitle: "Cancel", onClose: { print("Resume workout") })
            }
        }
        .onAppear() {
            if !workOutTimerModel.isStarted {
                workOutTimerModel.isStarted = true
            }
        }
    }
}

struct ExerciseList: View {
    
    //@State var isChecked: Bool = false
    @Binding var isActiveRestTimerView: Bool
    @State private var numberOfSets: Int = 1
    let id: String
    let name: String
    let onRemove: () -> Void
    let weight: Double = 0
    let reps: Int = 0
    
    @State private var isActiveRemoveExerciseDialog: Bool = false
    
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
                
                ForEach(1...numberOfSets, id: \.self) { set in
                    WorkoutOngoingSetList(set: set, weight: weight, reps: reps, isActiveRestTimerView: $isActiveRestTimerView)
                }
                
                BulkUpButton(text: "+ Add Set", color: .gray, isDisabled: false, isFullWidth: true, onClick: { numberOfSets += 1 })
                    .padding(.horizontal)
            }
            if isActiveRemoveExerciseDialog {
                BulkUpDialog(isActive: $isActiveRemoveExerciseDialog, title: "Remove Exercise?", message: "This removes", actionButtonTitle: "Cancel", action: { isActiveRemoveExerciseDialog = false }, cancelButtonTitle: "Remove", onClose: { isActiveRemoveExerciseDialog = false })
            }
        }
    }
}

#Preview {
    WorkoutOngoingView()
        .environmentObject(CountDownTimerModel())
        .environmentObject(CountUpTimerModel())
        .environmentObject(TimerSettings())
}
