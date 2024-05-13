//
//  ExercisesManager.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 11/5/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ExercisesManager {
    
    static let shared = ExercisesManager()
    private init() { }
    
    private let exercisesCollection = Firestore.firestore().collection("exercises")
    
    private func exerciseDocument(exerciseId: String) -> DocumentReference {
        exercisesCollection.document(exerciseId)
    }
    
    func uploadExercise(exercise: DBExercise) async throws {
        try exerciseDocument(exerciseId: String(exercise.id)).setData(from: exercise, merge: false)
    }
    
    func getExerciseById(exerciseId: String) async throws -> DBExercise {
        try await exerciseDocument(exerciseId: exerciseId).getDocument(as: DBExercise.self)
    }
    
    private func getAllExercisesQuery() -> Query {
        exercisesCollection
    }
    
    private func getExercisesByKeywordQuery(query: String) -> Query {
        exercisesCollection
            .whereField(DBExercise.CodingKeys.name.rawValue, isGreaterThanOrEqualTo: query)
            .whereField(DBExercise.CodingKeys.name.rawValue, isLessThanOrEqualTo: query+"\u{F7FF}")
    }
    
    private func getExercisesByFilterOptionQuery(option: ExerciseFilterOption, value: String) -> Query {
        exercisesCollection.whereField(option.rawValue, isEqualTo: value)
    }
    
    private func getExercisesByBodyPartAndCategoryQuery(bodyPart: BodyPart, category: ExerciseCategory) -> Query {
        exercisesCollection
            .whereField(DBExercise.CodingKeys.bodyPart.rawValue, isEqualTo: bodyPart.rawValue)
            .whereField(DBExercise.CodingKeys.category.rawValue, isEqualTo: category.rawValue)
    }
    
    private func getExercisesByKeywordAndBodyPartQuery(query: String, bodyPart: BodyPart) -> Query {
        exercisesCollection
            .whereField(DBExercise.CodingKeys.name.rawValue, isGreaterThanOrEqualTo: query)
            .whereField(DBExercise.CodingKeys.name.rawValue, isLessThanOrEqualTo: query+"\u{F7FF}")
            .whereField(DBExercise.CodingKeys.bodyPart.rawValue, isEqualTo: bodyPart.rawValue)
    }
    
    private func getExercisesByKeywordAndCategoryQuery(query: String, category: ExerciseCategory) -> Query {
        exercisesCollection
            .whereField(DBExercise.CodingKeys.name.rawValue, isGreaterThanOrEqualTo: query)
            .whereField(DBExercise.CodingKeys.name.rawValue, isLessThanOrEqualTo: query+"\u{F7FF}")
            .whereField(DBExercise.CodingKeys.category.rawValue, isEqualTo: category.rawValue)
    }
    
    private func getExercisesByKeywordAndAllFilterOptionsQuery(query: String, bodyPart: BodyPart, category: ExerciseCategory) -> Query {
        exercisesCollection
            .whereField(DBExercise.CodingKeys.name.rawValue, isGreaterThanOrEqualTo: query)
            .whereField(DBExercise.CodingKeys.name.rawValue, isLessThanOrEqualTo: query+"\u{F7FF}")
            .whereField(DBExercise.CodingKeys.bodyPart.rawValue, isEqualTo: bodyPart.rawValue)
            .whereField(DBExercise.CodingKeys.category.rawValue, isEqualTo: category.rawValue)
    }
    
    func getExercises(bodyPart: BodyPart?, category: ExerciseCategory?, searchText: String?, count: Int, lastDocument: DocumentSnapshot?) async throws -> (exercises: [DBExercise], lastDocument: DocumentSnapshot?) {
        var query: Query = getAllExercisesQuery()
        
        if let bodyPart, let category, let searchText {
            query = getExercisesByKeywordAndAllFilterOptionsQuery(query: searchText, bodyPart: bodyPart, category: category)
        } else if let bodyPart, let searchText {
            query = getExercisesByKeywordAndBodyPartQuery(query: searchText, bodyPart: bodyPart)
        } else if let category, let searchText {
            query = getExercisesByKeywordAndCategoryQuery(query: searchText, category: category)
        } else if let bodyPart, let category {
            query = getExercisesByBodyPartAndCategoryQuery(bodyPart: bodyPart, category: category)
        } else if let bodyPart {
            query = getExercisesByFilterOptionQuery(option: .bodyPart, value: bodyPart.rawValue)
        } else if let category {
            query = getExercisesByFilterOptionQuery(option: .category, value: category.rawValue)
        } else if let searchText {
            query = getExercisesByKeywordQuery(query: searchText)
        }
        
        return try await query
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: DBExercise.self)
    }
    
    func getAllExercisesCount() async throws -> Int {
        try await exercisesCollection.aggregateCount()
    }
    
}

