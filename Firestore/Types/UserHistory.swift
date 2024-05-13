//
//  UserHistory.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 14/5/2024.
//

import Foundation

struct UserHistoryWithInfo: Identifiable {
    let id: String
    let template: UserTemplateWithExercises
    let duration: Int
    let volume: Int
    let createdAt: Date?
    let updatedAt: Date?
}

struct UserHistory: Codable, Equatable {
    let id: String
    let templateId: String
    let duration: Int
    let volume: Int
    let createdAt: Date?
    let updatedAt: Date?
    
    init(userHistory: UserHistory) {
        self.id = userHistory.id
        self.templateId = userHistory.templateId
        self.duration = userHistory.duration
        self.volume = userHistory.volume
        self.createdAt = userHistory.createdAt
        self.updatedAt = userHistory.updatedAt
    }
    
    init(
        id: String,
        templateId: String,
        duration: Int,
        volume: Int,
        createdAt: Date?,
        updatedAt: Date?
    ) {
        self.id = id
        self.templateId = templateId
        self.duration = duration
        self.volume = volume
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case templateId = "template_id"
        case duration = "duration"
        case volume = "volume"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.templateId = try container.decode(String.self, forKey: .id)
        self.duration = try container.decode(Int.self, forKey: .duration)
        self.volume = try container.decode(Int.self, forKey: .duration)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.templateId, forKey: .templateId)
        try container.encode(self.duration, forKey: .duration)
        try container.encode(self.volume, forKey: .volume)
        try container.encode(self.createdAt, forKey: .createdAt)
        try container.encode(self.updatedAt, forKey: .updatedAt)
    }
}
