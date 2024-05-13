//
//  UserTemplate.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 14/5/2024.
//

import Foundation

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
    var exercise: DBExercise
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

struct UserTemplateWithExercises: Identifiable {
    let id: String
    let name: String
    var exercises: [UserTemplateExerciseWithExercise]
    let createdAt: Date?
    let updatedAt: Date?
}
