//
//  ExercisesManager.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 11/5/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBExercise: Codable, Equatable {
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
    
    static func ==(lhs: DBExercise, rhs: DBExercise) -> Bool {
        return lhs.id == rhs.id
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

extension Query {
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        try await getDocumentsWithSnapshot(as: type).exercises
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (exercises: [T], lastDocument: DocumentSnapshot?) where T: Decodable {
        let snapshot = try await self.getDocuments()
        
        let exercises = try snapshot.documents.map({ document in
            try document.data(as: T.self)
        })
        
        return (exercises, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else { return self }
        return self.start(afterDocument: lastDocument)
    }
    
    func aggregateCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
    
}
