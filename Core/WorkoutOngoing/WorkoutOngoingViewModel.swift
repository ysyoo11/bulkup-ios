//
//  WorkoutOngoingViewModel.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 14/5/2024.
//

import Foundation

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
    
    func updateCompletedExercises(exerciseIdx: Int, set: WorkoutSet, isChecked: Bool, setIdx: Int) {
        if isChecked {
            self.completedExercises[exerciseIdx].sets.append(set)
        } else {
            let newSets = self.completedExercises[exerciseIdx].sets.enumerated()
                .filter { $0.offset != setIdx }.map { $0.element }
            self.completedExercises[exerciseIdx].sets = newSets
        }
    }
    
    // TODO: Update History struct and save `completedExercises` to show details about completed exercises
    func saveHistory(templateId: String, durationSec: Int) {
        var volume = 0
        for exercise in self.completedExercises {
            for set in exercise.sets {
                volume += set.reps * Int(set.weight ?? 0)
            }
        }
        let history: UserHistory = UserHistory(
            id: "",
            templateId: templateId,
            duration: durationSec,
            volume: volume,
            createdAt: Date(),
            updatedAt: Date())
        
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.addUserHistory(userId: authDataResult.uid, history: history)
        }
    }
    
}
