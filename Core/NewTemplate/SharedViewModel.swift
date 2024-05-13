//
//  SharedViewModel.swift
//  BulkUp
//
//  Created by Suji Lee on 5/12/24.
//

import Foundation

class SharedViewModel: ObservableObject {
    @Published var selectedExercises: [ExerciseModel] = []
}
