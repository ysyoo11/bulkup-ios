//
//  WorkoutOngoingView.swift
//  BulkUp
//
//  Created by Yuta Horiuchi on 11/5/2024.
//

import SwiftUI

@MainActor
final class WorkoutOngoingViewModel: ObservableObject {
    
    @Published var selectedExercises: [DBExercise] = []
    @Published var ongoingExercises: [UserTemplateExerciseWithExercise] = []
    @Published var completedExercises: [UserTemplateExerciseWithExercise] = []
    
    func onExerciseTap(exercise: DBExercise) {
        if selectedExercises.contains(where: {$0.id == exercise.id}) {
            self.selectedExercises = selectedExercises.filter({ $0.id != exercise.id })
            return
        }
        self.selectedExercises.append(exercise)
    }
    
    func removeExercise(index: Int, from exercises: [UserTemplateExerciseWithExercise]){
        guard index >= 0 && index < exercises.count else {
            self.ongoingExercises = exercises
            return
        }
        
        self.ongoingExercises = exercises.enumerated().filter { $0.offset != index }.map { $0.element }
    }
    
    func addSelectedExercises(exercises: [DBExercise]) {
        let newlyAddedExercises = exercises.map { exercise in
            UserTemplateExerciseWithExercise(exercise: exercise, sets: [WorkoutSet(weight: 0, reps:0)], autoRestTimerSec: 90)
        }

        self.ongoingExercises = ongoingExercises + newlyAddedExercises
        self.selectedExercises = []
    }
    
    func addSet(index: Int, currentExercises: [UserTemplateExerciseWithExercise]) {
        self.ongoingExercises = currentExercises.enumerated().map { offset, exercise in
            var updatedExercise = exercise
            if offset == index {
                if let firstSet = exercise.sets.first {
                    let newSet = WorkoutSet(weight: firstSet.weight, reps: firstSet.reps)
                    updatedExercise.sets.append(newSet)
                } else {
                    let newSet = WorkoutSet(weight: 0.0, reps: 0)
                    updatedExercise.sets.append(newSet)
                }
            }
            return updatedExercise
        }
    }
    
    func removeSet(index: Int, currentExercises: [UserTemplateExerciseWithExercise]) {
        self.ongoingExercises = currentExercises.enumerated().map { offset, exercise in
            var updatedExercise = exercise
            if offset == index {
                if !updatedExercise.sets.isEmpty {
                    updatedExercise.sets.removeLast()
                }
            }
            return updatedExercise
        }
    }
    
    // FIXME:
    func updateCompletedExercises(exerciseIdx: Int, set: WorkoutSet, isChecked: Bool, setIdx: Int) {
        if isChecked {
            self.completedExercises[exerciseIdx].sets.append(set)
        } else {
            let newSets = self.completedExercises[exerciseIdx].sets.enumerated()
                .filter { $0.offset != setIdx }.map { $0.element }
            self.completedExercises[exerciseIdx].sets = newSets
        }
    }
    
}

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
                                exerciseIndex: offset
                            )
                        }
                        
                        VStack {
                            BulkUpButton(
                                text: "Add Exercises",
                                color: .skyblue,
                                isDisabled: false,
                                isFullWidth: true,
                                onClick: { showingExercisesView = true })
                            
                            BulkUpButton(
                                text: "Cancel Workout",
                                color: .pink,
                                isDisabled: false,
                                isFullWidth: true,
                                onClick: { isActiveCancelWorkoutDialog = true })
                        }
                        .padding()
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
                    action: { print("Close/Dispose WorkoutOngoingView") },
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
                        // TODO:
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
            print(viewModel.completedExercises)
        }
    }
}

struct ExerciseList: View {
    
    //@State var isChecked: Bool = false
    @Binding var isActiveRestTimerView: Bool
    let id: String
    let name: String
    let sets: [WorkoutSet]
    let onRemove: () -> Void
    let onAddSet: () -> Void
    let weight: Double = 0
    let reps: Int = 0
    let exerciseIndex: Int
    
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
                        repsStr: String(set.reps))
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
                BulkUpDialog(isActive: $isActiveRemoveExerciseDialog, title: "Remove Exercise?", message: "This removes", actionButtonTitle: "Cancel", action: {
                    onRemove()
                    isActiveRemoveExerciseDialog = false
                }, cancelButtonTitle: "Remove", onClose: { isActiveRemoveExerciseDialog = false })
            }
        }
    }
}

//#Preview {
//    WorkoutOngoingView()
//        .environmentObject(CountDownTimerModel())
//        .environmentObject(CountUpTimerModel())
//        .environmentObject(TimerSettings())
//}
