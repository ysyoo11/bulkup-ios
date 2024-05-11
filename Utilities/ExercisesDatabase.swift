//
//  ExercisesDatabase.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 11/5/2024.
//

import Foundation

enum BodyPart: String, Codable, CaseIterable {
    case legs = "legs"
    case back = "back"
    case chest = "chest"
    case shoulder = "shoulder"
    case arms = "arms"
    case core = "core"
    case fullBody = "full body"
}

enum ExerciseCategory: String, Codable, CaseIterable {
    case dumbbell = "dumbbell"
    case barbell = "barbell"
    case machine = "machine"
    case bodyWeight = "body weight"
    case cardio = "cardio"
}

struct Exercise: Identifiable, Codable {
    let id: String
    let name: String
    let bodyPart: BodyPart
    let category: ExerciseCategory
    let description: String
    let imageUrl: String?
}

final class ExerciseDatabase {
    
    static let exercises: [DBExercise] = [
        DBExercise(
            id: "1",
            name: "Squat",
            bodyPart: .legs,
            category: .barbell,
            description: "The barbell back squat is one of the most popular squat variations and makes up one of the three main powerlifting lifts. Using a barbell allows the squat to be loaded heavy, and also means you can increase the weight by smaller amounts to progress. It’s a great exercise for building both strength and hypertrophy, and a staple in many workouts.",
            imageUrl: "https://gymvisual.com/158-large_default/barbell-full-squat.jpg"
        ),
        DBExercise(
            id: "2",
            name: "Bench Press",
            bodyPart: .chest,
            category: .barbell,
            description: "This is a barbell bench press description",
            imageUrl: "https://gymvisual.com/19307-large_default/barbell-bench-press.jpg"
        ),
        DBExercise(
            id: "3",
            name: "Deadlift",
            bodyPart: .fullBody,
            category: .barbell,
            description: "This is deadlift",
            imageUrl: "https://gymvisual.com/15635-large_default/barbell-straight-leg-deadlift.jpg"
        )
    ]
    
}
