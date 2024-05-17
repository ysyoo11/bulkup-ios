//
//  NewTemplateViewModel.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 17/5/2024.
//

import Foundation
import Combine

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
            UserTemplateExerciseWithExercise(
                exercise: exercise,
                sets: [WorkoutSet(weight: 10, reps: 10)],
                autoRestTimerSec: 90)
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
    
    func setAutoRestTimer(index: Int, sec: Int, exercises: [UserTemplateExerciseWithExercise]) {
        self.stagedExercises = exercises.enumerated().map { offset, exercise in
            var updatedExercise = exercise
            if offset == index {
                updatedExercise.autoRestTimerSec = sec
            }
            return updatedExercise
        }
    }
    
    func disableAutoRestTimer(index: Int, exercises: [UserTemplateExerciseWithExercise]) {
        self.stagedExercises = exercises.enumerated().map { offset, exercise in
            var updatedExercise = exercise
            if offset == index {
                updatedExercise.autoRestTimerSec = nil
            }
            return updatedExercise
        }
    }
    
    func updateSet(exerciseIdx: Int, setIdx: Int, weight: Double?, reps: Int?) {
        self.stagedExercises = stagedExercises.enumerated().map { offset, exercise in
            var updatedExercise = exercise
            if offset == exerciseIdx {
                let updatedSets = exercise.sets.enumerated().map { setOffset, set in
                    setOffset == setIdx ? WorkoutSet(weight: weight ?? set.weight, reps: reps ?? set.reps) : set
                }
                updatedExercise.sets = updatedSets
            }
            return updatedExercise
        }
    }
    
    func addUserTemplate() {
        let userTemplateExerciseArray: [UserTemplateExercise] = self.stagedExercises.map { exercise in
            return UserTemplateExercise(
                exerciseId: exercise.exercise.id,
                sets: exercise.sets,
                autoRestTimerSec: exercise.autoRestTimerSec
            )
        }
        
        let template = UserTemplate(id: "", name: self.templateName, exercises: userTemplateExerciseArray, createdAt: Date(), updatedAt: Date())
        
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.addUserTemplate(userId: authDataResult.uid, template: template)
        }
    }
    
}
