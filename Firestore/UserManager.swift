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

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    private var userTemplatesListener: ListenerRegistration? = nil
    private var userHistoriesListener: ListenerRegistration? = nil
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
}

// Template
extension UserManager {
    
    private func userTemplatesCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("templates")
    }
    
    private func userTemplateDocument(userId: String, templateId: String) -> DocumentReference {
        userTemplatesCollection(userId: userId).document(templateId)
    }
    
    func addUserTemplate(userId: String, template: UserTemplate) async throws {
        let document = userTemplatesCollection(userId: userId).document()
        let documentId = document.documentID
        
        let encodedExercises = template.exercises.map { try? Firestore.Encoder().encode($0) }
        
        let data: [String: Any] = [
            UserTemplate.CodingKeys.id.rawValue: documentId,
            UserTemplate.CodingKeys.name.rawValue: template.name,
            UserTemplate.CodingKeys.exercises.rawValue: encodedExercises,
            UserTemplate.CodingKeys.createdAt.rawValue: Timestamp(date: Date()),
            UserTemplate.CodingKeys.updatedAt.rawValue: Timestamp(date: Date())
        ]
        
        do {
            try await document.setData(data, merge: false)
        } catch {
            print(error)
        }
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

// History
extension UserManager {
    
    private func userHistoriesCollection(userId: String) -> CollectionReference {
        userDocument(userId: userId).collection("histories")
    }
    
    private func userHistoryDocument(userId: String, historyId: String) -> DocumentReference {
        userHistoriesCollection(userId: userId).document(historyId)
    }
    
    func addListenerForAllUserHistories(userId: String) -> AnyPublisher<[UserHistory], any Error> {
        let (publisher, listener) = userHistoriesCollection(userId: userId)
            .addSnapshotListener(as: UserHistory.self)
        
        self.userHistoriesListener = listener
        return publisher
    }
    
    func removeListenerForAllUserHistories() {
        self.userHistoriesListener?.remove()
    }
    
    func addUserHistory(userId: String, history: UserHistory) async throws {
        let document = userHistoriesCollection(userId: userId).document()
        let documentId = document.documentID
        
        let data: [String: Any] = [
            UserHistory.CodingKeys.id.rawValue: documentId,
            UserHistory.CodingKeys.templateId.rawValue: history.templateId,
            UserHistory.CodingKeys.duration.rawValue: history.duration,
            UserHistory.CodingKeys.volume.rawValue: history.volume,
            UserHistory.CodingKeys.createdAt.rawValue: Timestamp(date: Date()),
            UserHistory.CodingKeys.updatedAt.rawValue: Timestamp(date: Date())
        ]
        
        do {
            try await document.setData(data)
        } catch {
            print(error)
        }
    }
    
    func removeUserHistory(userId: String, historyId: String) async throws {
        try await userHistoryDocument(userId: userId, historyId: historyId).delete()
    }
    
    func getAllUserHistories(userId: String) async throws -> [UserHistory] {
        try await userHistoriesCollection(userId: userId).getDocuments(as: UserHistory.self)
    }
    
    func getUserHistoryById(userId: String, historyId: String) async throws -> UserHistory {
        try await userHistoryDocument(userId: userId, historyId: historyId)
            .getDocument(as: UserHistory.self)
    }
    
}
