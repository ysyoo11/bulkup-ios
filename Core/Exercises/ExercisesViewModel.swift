//
//  ExercisesViewModel.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 12/5/2024.
//

import Foundation
import FirebaseFirestore

@MainActor
final class ExercisesViewModel: ObservableObject {
    
    @Published private(set) var exercises: [DBExercise] = []
    @Published var selectedBodyPart: BodyPart? = nil
    @Published var selectedCategory: ExerciseCategory? = nil
    @Published var searchQuery: String? = ""
    @Published var isReachingEnd: Bool = false
    
    private let count: Int = 20
    private var lastDocument: DocumentSnapshot? = nil
     
    func bodyPartFilterSelected(option: BodyPart?) async throws {
        self.selectedBodyPart = option ?? nil
        self.exercises = []
        self.lastDocument = nil
        self.isReachingEnd = false
        try await self.getExercises()
    }
    
    func categoryFilterSelected(option: ExerciseCategory?) async throws {
        self.selectedCategory = option ?? nil
        self.exercises = []
        self.lastDocument = nil
        self.isReachingEnd = false
        try await self.getExercises()
    }
    
    func searchExercisesByKeyword(query: String) async throws {
        self.searchQuery = query
        self.exercises = []
        self.lastDocument = nil
        self.isReachingEnd = false
        try await self.getExercises()
    }
    
    func getExercises() async throws {
        let (newExercises, lastDocument) = try await ExercisesManager.shared.getExercises(bodyPart: selectedBodyPart, category: selectedCategory, searchText: searchQuery, count: count, lastDocument: lastDocument)
        
        self.exercises.append(contentsOf: newExercises)
        if let lastDocument {
            self.lastDocument = lastDocument
        }
        if newExercises.count < count || newExercises.count == 0 {
            self.isReachingEnd = true
        }
    }
}
