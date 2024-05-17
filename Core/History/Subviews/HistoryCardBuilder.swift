//
//  HistoryCardBuilder.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 16/5/2024.
//

import SwiftUI

struct HistoryCardBuilder: View {
    
    let historyId: String
    @State private var history: UserHistoryWithInfo? = nil
    @Binding var selectedHistoryId: String
    @Binding var showingHistoryDetail: Bool
    
    var body: some View {
        ZStack {
            if let history {
                HistoryCard(history: history)
            }
        }
        .task {
            do {
                let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
                let userHistory = try await UserManager.shared.getUserHistoryById(userId: authDataResult.uid, historyId: historyId)
                let template = try await UserManager.shared.getUserTemplateById(userId: authDataResult.uid, templateId: userHistory.templateId)
                
                var exerciseArr: [UserTemplateExerciseWithExercise] = []
                for exercise in template.exercises {
                    if let dbExercise = try? await ExercisesManager.shared.getExerciseById(exerciseId: exercise.exerciseId) {
                        exerciseArr.append(UserTemplateExerciseWithExercise(exercise: dbExercise, sets: exercise.sets))
                    }
                }
                
                self.history = UserHistoryWithInfo(
                    id: userHistory.id,
                    template: UserTemplateWithExercises(
                        id: template.id,
                        name: template.name,
                        exercises: exerciseArr,
                        createdAt: template.createdAt,
                        updatedAt: template.updatedAt),
                    duration: userHistory.duration,
                    volume: userHistory.volume,
                    createdAt: userHistory.createdAt,
                    updatedAt: userHistory.updatedAt)
            } catch {
                print(error)
            }
        }
    }
    
}
