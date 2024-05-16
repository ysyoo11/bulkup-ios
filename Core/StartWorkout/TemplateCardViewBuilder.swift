//
//  TemplateCardViewBuilder.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 12/5/2024.
//

import SwiftUI

struct TemplateCardViewBuilder: View {
    
    let templateId: String
    @State private var template: UserTemplateWithExercises? = nil
    @Binding var selectedTemplateId: String
    @Binding var showingTemplatePreview: Bool
    
    var body: some View {
        ZStack {
            if let template {
                TemplateCard(selectedTemplateId: $selectedTemplateId, showingTemplatePreview: $showingTemplatePreview, template: template)
            }
        }
        .task {
            do {
                let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
                let userTemplate = try await UserManager.shared.getUserTemplateById(userId: authDataResult.uid, templateId: templateId)
                
                var exerciseArr: [UserTemplateExerciseWithExercise] = []
                for exercise in userTemplate.exercises {
                    if let dbExercise = try? await ExercisesManager.shared.getExerciseById(exerciseId: exercise.exerciseId) {
                        exerciseArr.append(UserTemplateExerciseWithExercise(exercise: dbExercise, sets: exercise.sets))
                    }
                }
                self.template = UserTemplateWithExercises(id: userTemplate.id, name: userTemplate.name, exercises: exerciseArr, createdAt: userTemplate.createdAt, updatedAt: userTemplate.updatedAt)
            } catch {
                print(error)
            }
        }
    }
}
