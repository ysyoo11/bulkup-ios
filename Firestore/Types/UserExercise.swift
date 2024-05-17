//
//  UserExercise.swift
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

struct Record {
    var id: String
    var createdAt: Date
    var updatedAt: Date
    var sets: [WorkoutSet]
}
