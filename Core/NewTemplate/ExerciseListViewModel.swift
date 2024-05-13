//
//  ExerciseListViewModel.swift
//  BulkUp
//
//  Created by Suji Lee on 5/12/24.
//

import Foundation

class ExerciseListViewModel: ObservableObject {
    @Published var exercises: [ExerciseModel] = ExerciseModel.exerciseList
    @Published var selectedExercises: [ExerciseModel] = []

    func addExercise(_ exercise: ExerciseModel) {
        if !selectedExercises.contains(where: { $0.id == exercise.id }) {
            selectedExercises.append(exercise)
        }
    }
}
