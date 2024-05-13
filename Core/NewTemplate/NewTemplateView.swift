//
//  NewTemplateView.swift
//  BulkUp
//
//  Created by Eunbyul Cho on 9/5/2024.
//

import SwiftUI
import Foundation
import Combine

import Foundation

@MainActor
final class NewTemplateViewModel: ObservableObject {
    
    @Published var templateName: String = ""
    @Published var templateNote: String = ""
    
    @Published var selectedExercises: [DBExercise] = []
    @Published var stagedExercises: [UserTemplateExerciseWithExercise] = []
    
    func onExerciseTap(exercise: DBExercise) {
        if selectedExercises.contains(where: {$0.id == exercise.id}) {
            self.selectedExercises = selectedExercises.filter({ $0.id != exercise.id })
            return
        }
        self.selectedExercises.append(exercise)
    }
    
    func stageSelectedExercises(exercises: [DBExercise]) {
        let newlyAddedExercises = exercises.map { exercise in
            UserTemplateExerciseWithExercise(exercise: exercise, sets: [WorkoutSet(weight: 0, reps:0)], autoRestTimerSec: 90)
        }

        self.stagedExercises = stagedExercises + newlyAddedExercises
        self.selectedExercises = []
    }
    
    func removeExercise(index: Int, from exercises: [UserTemplateExerciseWithExercise]){
        guard index >= 0 && index < exercises.count else {
            self.stagedExercises = exercises
            return
        }
        
        self.stagedExercises = exercises.enumerated().filter { $0.offset != index }.map { $0.element }
    }
    
    func addSet(index: Int, stagedExercises: [UserTemplateExerciseWithExercise]) {
        self.stagedExercises = stagedExercises.enumerated().map { offset, exercise in
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
    
    func removeSet(index: Int, stagedExercises: [UserTemplateExerciseWithExercise]) {
        self.stagedExercises = stagedExercises.enumerated().map { offset, exercise in
            var updatedExercise = exercise
            if offset == index {
                if !updatedExercise.sets.isEmpty {
                    updatedExercise.sets.removeLast()
                }
            }
            return updatedExercise
        }
    }
    
    // FIXME: Not applied to self.stagedExercises
    func setAutoRestTimer(index: Int, sec: Int, exercises: [UserTemplateExerciseWithExercise]) {
        self.stagedExercises = exercises.enumerated().map { offset, exercise in
            var updatedExercise = exercise
            if offset == index {
                updatedExercise.autoRestTimerSec = sec
            }
            return updatedExercise
        }
    }
    // FIXME: Not applied to self.stagedExercises
    func disableAutoRestTimer(index: Int, exercises: [UserTemplateExerciseWithExercise]) {
        self.stagedExercises = exercises.enumerated().map { offset, exercise in
            var updatedExercise = exercise
            if offset == index {
                updatedExercise.autoRestTimerSec = nil
            }
            return updatedExercise
        }
    }
    
    func addUserTemplate() {
        let userTemplateExerciseArray: [UserTemplateExercise] = self.stagedExercises.map { exercise in
            return UserTemplateExercise(exerciseId: exercise.exercise.id, sets: exercise.sets, autoRestTimerSec: exercise.autoRestTimerSec)
        }
        
        let template = UserTemplate(id: "", name: self.templateName, exercises: userTemplateExerciseArray, createdAt: Date(), updatedAt: Date())
        
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.addUserTemplate(userId: authDataResult.uid, template: template)
        }
    }
    
}

struct NewTemplateView: View {
    @StateObject private var viewModel = NewTemplateViewModel()
    
    @Binding var isPresented: Bool
    @State private var templateName: String = ""
    @State private var showingRestTimerSetupView: Bool = false
    @State private var showingExercisesView: Bool = false
    @State private var selectedExerciseIndex: Int = 0
    @State private var selectedExercise: UserTemplateExerciseWithExercise?
    @State private var currentStagedExercises: [UserTemplateExerciseWithExercise] = []
    
    @State private var exampleExercises = [BulkUp.UserTemplateExerciseWithExercise(exercise: BulkUp.DBExercise(id: "23", name: "Back Extension", bodyPart: BulkUp.BodyPart.back, category: BulkUp.ExerciseCategory.machine, description: "Strengthens the lower back muscles by lifting the upper body against resistance while lying face down. This exercise is critical for back health and core stability.", imageUrl: Optional("https://gymvisual.com/19012-large_default/45-degrees-back-extension.jpg")), sets: [BulkUp.WorkoutSet(weight: Optional(0.0), reps: 0)]), BulkUp.UserTemplateExerciseWithExercise(exercise: BulkUp.DBExercise(id: "3", name: "Bench Press", bodyPart: BulkUp.BodyPart.chest, category: BulkUp.ExerciseCategory.barbell, description: "Targets the pectoral muscles by pressing a weight upwards from a bench-lying position. This essential upper body exercise also engages the shoulders and triceps, improving upper body strength and muscle mass.", imageUrl: Optional("https://gymvisual.com/33869-large_default/barbell-wide-bench-press-female.jpg")), sets: [BulkUp.WorkoutSet(weight: Optional(0.0), reps: 0)]), BulkUp.UserTemplateExerciseWithExercise(exercise: BulkUp.DBExercise(id: "5", name: "Biceps Curl", bodyPart: BulkUp.BodyPart.arms, category: BulkUp.ExerciseCategory.dumbbell, description: "Focuses on the biceps by curling weights from a hanging position to shoulder height. This exercise is fundamental for building arm strength and muscle definition, ensuring balanced arm development.", imageUrl: Optional("https://gymvisual.com/20395-large_default/dumbbell-waiter-biceps-curl.jpg")), sets: [BulkUp.WorkoutSet(weight: Optional(0.0), reps: 0)]), BulkUp.UserTemplateExerciseWithExercise(exercise: BulkUp.DBExercise(id: "7", name: "Burpees", bodyPart: BulkUp.BodyPart.fullBody, category: BulkUp.ExerciseCategory.bodyWeight, description: "A dynamic full-body exercise that combines a squat, jump, and push-up. Excellent for building strength and endurance, it also boosts cardiovascular fitness and burns a significant amount of calories.", imageUrl: Optional("https://gymvisual.com/33072-large_default/jack-burpee-male.jpg")), sets: [BulkUp.WorkoutSet(weight: Optional(0.0), reps: 0)])]
    
    private func onAdd(exercises: [DBExercise]) {
        viewModel.stageSelectedExercises(exercises: exercises)
        showingExercisesView = false
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .imageScale(.large)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Text("New Template")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    BulkUpButton(
                        text: "Save",
                        color: .blue,
                        isDisabled: viewModel.stagedExercises.isEmpty || viewModel.templateName.isEmpty,
                        onClick: {
                            viewModel.addUserTemplate()
                            isPresented = false
                    })
                }
                .padding(.horizontal, 10)
                
                ScrollView {
                    BulkUpTextField(placeholder: "Template name", type: .noBorder, size: .lg, text: $viewModel.templateName)
                        .padding(.horizontal, 10)
                    
                    VStack {
                        ForEach(Array(viewModel.stagedExercises.enumerated()), id: \.offset) { offset, item in
                            VStack {
                                HStack {
                                    Text("\(item.exercise.name) (\(item.exercise.category.rawValue.capitalized))")
                                        .font(.headline)
                                        .foregroundStyle(.primaryBlue)
                                        .underline()
                                    
                                    Spacer()
                                    
                                    BulkUpButton(text: "Timer", color: .clear, isDisabled: false, onClick: {
                                        currentStagedExercises = viewModel.stagedExercises
                                        selectedExerciseIndex = offset
                                        selectedExercise = item
                                        showingRestTimerSetupView = true
                                    })
                                    BulkUpMenu(options: [
                                        .option(text: "Remove Exercise", icon: "xmark", action: {
                                            viewModel.removeExercise(index: offset, from: viewModel.stagedExercises)
                                        })
                                    ])
                                }
                                VStack(spacing: 5) {
                                    ForEach(Array(item.sets.enumerated()), id: \.offset) { index, set in
                                        SetList(set: index + 1, weight: set.weight ?? 0, reps: set.reps, type: .edit, onDelete: {
                                            viewModel.removeSet(index: offset, stagedExercises: viewModel.stagedExercises)
                                        })
                                    }
                                    BulkUpButton(text: "+ Add Set", color: .gray, isDisabled: false, isFullWidth: true, size: .sm, onClick: {
                                        viewModel.addSet(index: offset, stagedExercises: viewModel.stagedExercises)
                                    })
                                }
                            }
                            .padding(.bottom, 20)
                        }
                        BulkUpButton(text: "Add Exercises", color: .skyblue, isDisabled: false, isFullWidth: true, onClick: {
                            showingExercisesView = true
                        })
                        .padding(.top, 10)
                    }
                    .padding(.top, 30)
                    .padding(.horizontal, 20)
                }

                Spacer()
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingExercisesView) {
                ExercisesViewSheet(isPresented: $showingExercisesView, isNewTemplateMode: true, onAdd: onAdd)
            }
            .sheet(isPresented: $showingRestTimerSetupView) {
                RestTimerSetupView(
                    exerciseIndex: $selectedExerciseIndex,
                    exercise: $selectedExercise,
                    currentStagedExercises: $currentStagedExercises)
            }
        }
    }
}

struct NewTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        NewTemplateView(isPresented: .constant(true))
    }
}
