//
//  Types.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 8/5/2024.
//

import Foundation

struct UserExercise {
    var id: String
    var exercise: Exercise
    var records: [Record]
    var autoRestTimer: Int? // sec
}

//struct Template {
//    var id: String
//    var name: String
//    var exercises: [DBExercise]
//    var createdAt: Date
//    var updatedAt: Date
//}

struct History {
    var id: String
    var template: UserTemplate?
    var createdAt: Date
    var endedAt: Date
    var updatedAt: Date
    var volume: Int
}

struct Record {
    var id: String
    var createdAt: Date
    var updatedAt: Date
    var sets: [WorkoutSet]
}

extension Date {
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
}
