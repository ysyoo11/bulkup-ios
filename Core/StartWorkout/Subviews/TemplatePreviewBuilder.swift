//
//  TemplatePreviewBuilder.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 13/5/2024.
//

import SwiftUI

struct TemplatePreviewBuilder: View {
    @Binding var selectedTemplateId: String
    @Binding var showingTemplatePreview: Bool
    @State private var template: UserTemplateWithExercises? = nil
    
    var body: some View {
        ZStack {
            if let template {
                TemplatePreview(
                    showingTemplatePreview: $showingTemplatePreview, 
                    previewTemplateId: $selectedTemplateId,
                    template: template)
            }
        }
        .task {
            do {
                let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
                let userTemplate = try await UserManager.shared.getUserTemplateById(userId: authDataResult.uid, templateId: selectedTemplateId)
                
                var exerciseArr: [UserTemplateExerciseWithExercise] = []
                for exercise in userTemplate.exercises {
                    if let dbExercise = try? await ExercisesManager.shared.getExerciseById(exerciseId: exercise.exerciseId) {
                        exerciseArr.append(UserTemplateExerciseWithExercise(exercise: dbExercise, sets: exercise.sets, autoRestTimerSec: exercise.autoRestTimerSec))
                    }
                }
                self.template = UserTemplateWithExercises(
                    id: userTemplate.id,
                    name: userTemplate.name,
                    exercises: exerciseArr,
                    createdAt: userTemplate.createdAt,
                    updatedAt: userTemplate.updatedAt)
            } catch {
                print(error)
            }
        }
    }
}

