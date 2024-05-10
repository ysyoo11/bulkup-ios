//
//  UserManager.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 10/5/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser {
    let userId: String
    let email: String?
    let photoUrl: String?
    let createdAt: Date?
    let username: String?
}

final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        var userData: [String: Any] = [
            "user_id": auth.uid,
            "created_at": Timestamp(),
        ]
        if let email = auth.email {
            userData["email"] = email
        }
        if let photoUrl = auth.photoUrl {
            userData["photo_url"] = photoUrl
        }
        if let username = auth.username {
            userData["username"] = username
        }
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let email = data["email"] as? String
        let photoUrl = data["photo_url"] as? String
        let createdAt = data["created_at"] as? Date
        let username = data["username"] as? String
        
        return DBUser(userId: userId, email: email, photoUrl: photoUrl, createdAt: createdAt, username: username)
    }
    
}
