//
//  ExercisesManager.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 11/5/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBExercise: Codable {
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

final class ExercisesManager {
    
    static let shared = ExercisesManager()
    private init() { }
    
    private let exercisesCollection = Firestore.firestore().collection("exercises")
    
    private func exerciseDocument(exerciseId: String) -> DocumentReference {
        exercisesCollection.document(exerciseId)
    }
    
    func uploadExercise(exercise: Exercise) async throws {
        try exerciseDocument(exerciseId: String(exercise.id)).setData(from: exercise, merge: false)
    }
    
    func getAllExercises() async throws -> [DBExercise] {
        let snapshot = try await exercisesCollection.getDocuments()
        
        var exercises: [DBExercise] = []
        for document in snapshot.documents {
            do {
                let exercise = try document.data(as: DBExercise.self)
                exercises.append(exercise)
            } catch {
                print(error)
            }
        }
        
        return exercises
    }
}