//
//  UserManager.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 10/5/2024.
//

import Combine
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    let userId: String
    let email: String?
    let photoUrl: String?
    let createdAt: Date?
    let username: String?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.createdAt = Date()
        self.username = auth.username
    }
    
    init(
        userId: String,
        email: String? = nil,
        photoUrl: String? = nil,
        createdAt: Date? = nil,
        username: String? = nil
    ) {
        self.userId = userId
        self.email = email
        self.photoUrl = photoUrl
        self.createdAt = createdAt
        self.username = username
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case photoUrl = "photo_url"
        case createdAt = "created_at"
        case username = "username"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.username = try container.decodeIfPresent(String.self, forKey: .username)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.createdAt, forKey: .createdAt)
        try container.encodeIfPresent(self.username, forKey: .username)
    }
}

struct UserTemplateExercise: Codable, Equatable {
    let exerciseId: String
    let sets: [WorkoutSet]
    let autoRestTimerSec: Int?
    
    init(userTemplateExercise: UserTemplateExercise) {
        self.exerciseId = userTemplateExercise.exerciseId
        self.sets = userTemplateExercise.sets
        self.autoRestTimerSec = userTemplateExercise.autoRestTimerSec
    }
    
    init(
        exerciseId: String,
        sets: [WorkoutSet],
        autoRestTimerSec: Int?
    ) {
        self.exerciseId = exerciseId
        self.sets = sets
        self.autoRestTimerSec = autoRestTimerSec
    }
    
    enum CodingKeys: String, CodingKey {
        case exerciseId = "exercise_id"
        case sets = "sets"
        case autoRestTimerSec = "auto_rest_timer_sec"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.exerciseId = try container.decode(String.self, forKey: .exerciseId)
        self.sets = try container.decode([WorkoutSet].self, forKey: .sets)
        self.autoRestTimerSec = try container.decodeIfPresent(Int.self, forKey: .autoRestTimerSec)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.exerciseId, forKey: .exerciseId)
        try container.encode(self.sets, forKey: .sets)
        try container.encode(self.autoRestTimerSec, forKey: .autoRestTimerSec)
    }
}
struct UserTemplateExerciseWithExercise: Equatable {
    let exercise: DBExercise
    var sets: [WorkoutSet]
    var autoRestTimerSec: Int?
}

struct WorkoutSet: Codable, Equatable {
    let weight: Double?
    let reps: Int
    
    init(workoutSet: WorkoutSet) {
        self.weight = workoutSet.weight
        self.reps = workoutSet.reps
    }
    
    init(
        weight: Double?,
        reps: Int
    ) {
        self.weight = weight
        self.reps = reps
    }
    
    enum CodingKeys: String, CodingKey {
        case weight = "weight"
        case reps = "reps"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.weight = try container.decodeIfPresent(Double.self, forKey: .weight)
        self.reps = try container.decode(Int.self, forKey: .reps)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.weight, forKey: .weight)
        try container.encode(self.reps, forKey: .reps)
    }
}

struct UserTemplate: Codable {
    let id: String
    let name: String
    let exercises: [UserTemplateExercise]
    let createdAt: Date?
    let updatedAt: Date?
    
    init(template: UserTemplate) {
        self.id = template.id
        self.name = template.name
        self.exercises = template.exercises
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    init(
        id: String,
        name: String,
        exercises: [UserTemplateExercise],
        createdAt: Date? = nil,
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.exercises = exercises
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case exercises = "exercises"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.exercises = try container.decode([UserTemplateExercise].self, forKey: .exercises)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.exercises, forKey: .exercises)
        try container.encodeIfPresent(self.createdAt, forKey: .createdAt)
        try container.encodeIfPresent(self.updatedAt, forKey: .updatedAt)
    }
}

struct UserTemplateWithExercises {
    let id: String
    let name: String
    let exercises: [UserTemplateExerciseWithExercise]
    let createdAt: Date?
    let updatedAt: Date?
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private func userTemplatesCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("templates")
    }
    
    private func userTemplateDocument(userId: String, templateId: String) -> DocumentReference {
        userTemplatesCollection(userId: userId).document(templateId)
    }
    
    private var userTemplatesListener: ListenerRegistration? = nil
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func addUserTemplate(userId: String, template: UserTemplate) async throws {
        let document = userTemplatesCollection(userId: userId).document()
        let documentId = document.documentID
        
        let data: [String: Any] = [
            UserTemplate.CodingKeys.id.rawValue: documentId,
            UserTemplate.CodingKeys.name.rawValue: template.name,
            UserTemplate.CodingKeys.exercises.rawValue: template.exercises,
            UserTemplate.CodingKeys.createdAt.rawValue: Timestamp(),
            UserTemplate.CodingKeys.updatedAt.rawValue: Timestamp()
        ]
        
        try await document.setData(data, merge: false)
    }
    
    func removeUserTemplate(userId: String, templateId: String) async throws {
        try await userTemplateDocument(userId: userId, templateId: templateId).delete()
    }
    
    func getAllUserTemplates(userId: String) async throws -> [UserTemplate] {
        try await userTemplatesCollection(userId: userId).getDocuments(as: UserTemplate.self)
    }
    
    func getUserTemplateById(userId: String, templateId: String) async throws -> UserTemplate {
        try await userTemplateDocument(userId: userId, templateId: templateId).getDocument(as: UserTemplate.self)
    }
    
    func removeListenerForAllUserTemplates() {
        self.userTemplatesListener?.remove()
    }
    
    func addListenerForAllUserTemplates(userId: String) -> AnyPublisher<[UserTemplate], any Error> {
        let (publisher, listener) = userTemplatesCollection(userId: userId)
            .addSnapshotListener(as: UserTemplate.self)
        
        self.userTemplatesListener = listener
        return publisher
    }
    
}
