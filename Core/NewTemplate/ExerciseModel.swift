//
//  ExerciseModel.swift
//  BulkUp
//
//  Created by Suji Lee on 5/9/24.
//
import SwiftUI

struct ExerciseSet: Identifiable, Hashable {
    let id: String = UUID().uuidString
    var weight: Int
    var reps: Int
}

struct ExerciseModel: Hashable, Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let bodyPart: String
    let tool: String
    var imageName: String
    let instruction: String
    let isChecked: Bool = false
    var sets: [ExerciseSet] = [ExerciseSet(weight: 0, reps: 0)] // initialize with one default set
}

extension ExerciseModel {
    static let exerciseList: [ExerciseModel] = [
        ExerciseModel(name: "Squat", bodyPart: "Legs", tool: "Barbell", imageName: "squat", instruction: "1. Grip the barbell and stand up to lift it off the rack\n\n2. Step back with each leg until you are clear of the rack, setting up your footing for the lift\n\n3. Lower yourself until your thighs are at most parallel to the floor\n\n4. Raise yourself back up to standing\n\n5. Step forward to rerack the barbell"),
        ExerciseModel(name: "Seated Row", bodyPart: "Back", tool: "Cable", imageName: "seatedRow", instruction: "1. Connect the close-grip attachment to the seated row. Place both hands on the close-grip attachment with a neutral grip (palms facing inwards). Sit on the bench and place your feet on the foot plates. Hold the attachment directly in front of your belly button with arms extended. Pull your shoulder blades down and back slightly to push your chest out. This is your starting position.\n\n2. Inhale. Exhale. While maintaining a proud chest, bend your elbows to pull the attachment in towards your belly button, ensuring that your elbows remain in close contact with the sides of your body. You should feel a small squeeze between your shoulder blades.\n\n3. Inhale. Extend your elbows to return to the starting position. Repeat for the specified number of repetitions."),
        ExerciseModel(name: "Lying Triceps Extension", bodyPart: "Arms", tool: "Cable", imageName: "lyingTricepsExtension", instruction: "1. Lie on a flat bench with feet on the ground and head hanging just off the top of the bench, so that the edge of the bench rests in the pit between neck and head.\n\n2. Take the barbell with an overhand grip (palms away from body) and hold it out above the head so that the arms are supporting the weight. Do not hold the arms straight over the face at 12 o'clock, but rather at an angle more like 10 o'clock, with feet at 3 o'clock. All of the weight should be on the triceps.\n\n3. Now bend the arms at the elbow, bringing the bar down close to the top of the forehead.\n\n4. Keep the elbows in the same position, do not let them sway outward.\n\n5. Press back up to starting 10 o’clock position."),
        ExerciseModel(name: "Bicep Curl", bodyPart: "Arms", tool: "Cable", imageName: "bicepCurl", instruction: "1. Hold the bar that is attached to a pulley at the lowest level in a standing position, step a foot back from the pulley to create a comfortable angle for this exercise.\n\n2. Keep the elbows to the side of the torso and shoulders are fixed, then raise the bar towards shoulder until biceps are fully contracted.\n\n3. Return the bar back to the initial position for another repetition.")
    ]
}
