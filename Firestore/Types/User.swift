//
//  User.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 14/5/2024.
//

import Foundation

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
