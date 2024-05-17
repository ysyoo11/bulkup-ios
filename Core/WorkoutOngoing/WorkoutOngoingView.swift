//
//  WorkoutOngoingView.swift
//  BulkUp
//
//  Created by Yuta Horiuchi on 11/5/2024.
//

import SwiftUI

struct WorkoutOngoingView: View {
    
    @EnvironmentObject var restTimerModel: CountDownTimerModel
    @EnvironmentObject var workOutTimerModel: CountUpTimerModel
    @EnvironmentObject var timerSettings: TimerSettings
    
    @StateObject private var viewModel = WorkoutOngoingViewModel()
    
    var template: UserTemplateWithExercises
    
    @State private var isActiveRestTimerView: Bool = false
    @State private var isActiveAddExerciseView: Bool = false
    @State private var isActiveCancelWorkoutDialog: Bool = false
    @State private var isActiveFinishWorkoutDialog: Bool = false
    
    @State private var showingExercisesView: Bool = false
    
    private func onAdd(exercises: [DBExercise]) {
        viewModel.addSelectedExercises(exercises: exercises)
        showingExercisesView = false
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack (alignment: .leading, spacing: 0) {
                        
                        VStack (alignment: .leading, spacing: 0){
                            Text(template.name)
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
                        
                        ForEach(Array(viewModel.ongoingExercises.enumerated()), id: \.element.exercise.id.self) { offset, exercise in
                            ExerciseList(
                                isActiveRestTimerView: $isActiveRestTimerView,
                                id: exercise.exercise.id,
                                name: exercise.exercise.name,
                                sets: exercise.sets,
                                autoRestTimer: exercise.autoRestTimerSec,
                                onRemove: {
                                    viewModel.removeExercise(
                                        index: offset,
                                        from: viewModel.ongoingExercises)
                                },
                                onAddSet: {
                                    viewModel.addSet(
                                        index: offset,
                                        currentExercises: viewModel.ongoingExercises)
                                },
                                exerciseIndex: offset,
                                updateCompletedExercises: viewModel.updateCompletedExercises
                            )
                        }
                        
                        VStack {
//                            BulkUpButton(
//                                text: "Add Exercises",
//                                color: .skyblue,
//                                isDisabled: false,
//                                isFullWidth: true,
//                                onClick: { showingExercisesView = true })
                            
                            BulkUpButton(
                                text: "Cancel Workout",
                                color: .pink,
                                isDisabled: false,
                                isFullWidth: true,
                                onClick: { isActiveCancelWorkoutDialog = true })
                        }
                        .padding()
                        .padding(.top, 10)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        SetListButton(
                            text: restTimerModel.isStarted
                                ? restTimerModel.timerStringValue
                                : "Timer",
                            foregroundColor: .primaryGray,
                            backgroundColor: .secondaryGray,
                            action: { isActiveRestTimerView = true })
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        SetListButton(
                            text: "Finish",
                            foregroundColor: .white,
                            backgroundColor: .primaryGreen,
                            action: { isActiveFinishWorkoutDialog = true })
                    }
                }
                .padding(.top, 20)
            }
            if isActiveRestTimerView {
                RestTimerView(
                    isActive: $isActiveRestTimerView,
                    duration: timerSettings.timer)
//                    .environmentObject(CountDownTimerModel())
            }
            if isActiveAddExerciseView {
                //Open View to add exercise
            }
            if isActiveCancelWorkoutDialog {
                BulkUpDialog(
                    isActive: $isActiveCancelWorkoutDialog,
                    type: .alert,
                    title: "Cancel Workout?",
                    message: "Are you sure you want to cancel this workout? All progress will be lost.",
                    actionButtonTitle: "Cancel Workout",
                    action: {
                        workOutTimerModel.stopTimer()
                    },
                    cancelButtonTitle: "Resume",
                    onClose: { print("Resume workout") })
            }
            if isActiveFinishWorkoutDialog {
                BulkUpDialog(
                    isActive: $isActiveFinishWorkoutDialog,
                    type: .confirm,
                    title: "🎉",
                    message: "Finish Workout?",
                    actionButtonTitle: "Finish",
                    action: {
                        workOutTimerModel.stopTimer()
                        viewModel.saveHistory(templateId: template.id, durationSec: workOutTimerModel.minutes)
                    },
                    cancelButtonTitle: "Cancel",
                    onClose: { print("Resume workout") })
            }
        }
        .sheet(isPresented: $showingExercisesView) {
            OngoingExercisesViewSheet(
                isPresented: $showingExercisesView,
                isNewTemplateMode: true,
                onAdd: onAdd)
        }
        .onAppear() {
            if !workOutTimerModel.isStarted {
                workOutTimerModel.isStarted = true
            }
        }
        .onFirstAppear {
            viewModel.ongoingExercises = template.exercises
            viewModel.completedExercises = template.exercises.map { exercise in
                var setsEmptiedExercise = exercise
                setsEmptiedExercise.sets = []
                return setsEmptiedExercise
            }
        }
        .toolbar(.hidden)
    }
}

//#Preview {
//    WorkoutOngoingView()
//        .environmentObject(CountDownTimerModel())
//        .environmentObject(CountUpTimerModel())
//        .environmentObject(TimerSettings())
//}
