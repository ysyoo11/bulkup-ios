//
//  ExercisesManager.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 11/5/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBExercise: Codable, Hashable {
    let id: String
    let name: String
    let bodyPart: BodyPart
    let category: ExerciseCategory
    let description: String
    let imageUrl: String?
    
    init(exercise: Exercise) {
        self.id = exercise.id
        self.name = exercise.name
        self.bodyPart = exercise.bodyPart
        self.category = exercise.category
        self.description = exercise.description
        self.imageUrl = exercise.imageUrl
    }
    
    init(
        id: String,
        name: String,
        bodyPart: BodyPart,
        category: ExerciseCategory,
        description: String,
        imageUrl: String?
    ) {
        self.id = id
        self.name = name
        self.bodyPart = bodyPart
        self.category = category
        self.description = description
        self.imageUrl = imageUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case bodyPart = "body_part"
        case category = "category"
        case description = "description"
        case imageUrl = "image_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.bodyPart = try container.decode(BodyPart.self, forKey: .bodyPart)
        self.category = try container.decode(ExerciseCategory.self, forKey: .category)
        self.description = try container.decode(String.self, forKey: .description)
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.bodyPart, forKey: .bodyPart)
        try container.encode(self.category, forKey: .category)
        try container.encode(self.description, forKey: .description)
        try container.encodeIfPresent(self.imageUrl, forKey: .imageUrl)
    }
}

enum ExerciseFilterOption: String {
    case bodyPart = "body_part"
    case category = "category"
}

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
    
    func getAllExercises() async throws -> [DBExercise] {
        try await exercisesCollection.getDocuments(as: DBExercise.self)
    }
    
    func getExercisesByKeyword(query: String) async throws -> [DBExercise] {
        try await exercisesCollection
            .whereField("name", isGreaterThanOrEqualTo: query)
            .whereField("name", isLessThanOrEqualTo: query+"\u{F7FF}")
            .getDocuments(as: DBExercise.self)
    }
    
    func getExercisesByFilterOption(option: ExerciseFilterOption, value: String) async throws -> [DBExercise] {
        try await exercisesCollection.whereField(option.rawValue, isEqualTo: value).getDocuments(as: DBExercise.self)
    }
}

extension Query {
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        let snapshot = try await self.getDocuments()
        
        return try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
    }
    
}
