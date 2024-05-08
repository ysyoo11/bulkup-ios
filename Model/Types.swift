//
//  Types.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 8/5/2024.
//

import Foundation

enum BodyPart: String {
    case legs = "legs"
    case back = "back"
    case chest = "chest"
    case shoulder = "shoulder"
    case arms = "arms"
    case core = "core"
    case fullBody = "full body"
}

enum ExerciseCategory: String {
    case dumbbell = "dumbbell"
    case barbell = "barbell"
    case machine = "machine"
    case bodyWeight = "body weight"
    case cardio = "cardio"
}

struct Exercise {
    var id: String
    var name: String
    var bodyPart: BodyPart
    var type: ExerciseCategory
    var description: String
    var imageUrl: String
}

struct Record {
    var id: String
    var weight: Double?
    var reps: Int
}

struct ExerciseWithRecord {
    var id: String
    var exerciseId: String // only store Exercise id
    var records: [String] // only store Record id
    var autoRestTimer: Int?
}

struct Template {
    var id: String
    var name: String
    var exercisesWithRecord: [String] // only store ExerciseWithRecord id
    var authorId: String
}

struct History {
    var id: String
    var template: String // only store Template id
    var duration: Int
    var createdAt: Date
    var volume: Int
    var userId: String
}

struct User {
    var id: String
    var username: String
    var createdAt: Date
    var histories: [String] // only store history id
}
