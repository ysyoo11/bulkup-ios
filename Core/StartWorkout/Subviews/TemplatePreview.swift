//
//  TemplatePreview.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 13/5/2024.
//

import SwiftUI
import ModalView

@MainActor
final class TemplatePreviewViewModel: ObservableObject {
    
    @Published private(set) var template: UserTemplateWithExercises?
    
    func getTemplateById(templateId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            let dbTemplate = try await UserManager.shared.getUserTemplateById(userId: authDataResult.uid, templateId: templateId)
            
            let dbTemplateExercises = dbTemplate.exercises
            
            var exercises: [UserTemplateExerciseWithExercise] = []
            for dbTemplateExercise in dbTemplateExercises {
                let exercise = try await ExercisesManager.shared.getExerciseById(exerciseId: dbTemplateExercise.exerciseId)
                exercises.append(UserTemplateExerciseWithExercise(exercise: exercise, sets: dbTemplateExercise.sets, autoRestTimerSec: dbTemplateExercise.autoRestTimerSec))
            }
            
            self.template = UserTemplateWithExercises(id: templateId, name: dbTemplate.name, exercises: exercises, createdAt: dbTemplate.createdAt, updatedAt: dbTemplate.updatedAt)
        }
    }
}

struct TemplatePreview: View {
    @StateObject private var viewModel = TemplatePreviewViewModel()
    
    @Binding var showingTemplatePreview: Bool
    @Binding var previewTemplateId: String
    
    var template: UserTemplateWithExercises
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        showingTemplatePreview = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                    .tint(.black)
                    .padding()
                    
                    Spacer()
                    
                    Text(template.name)
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    BulkUpButton(
                        text: "Edit",
                        color: .clear,
                        isDisabled: false,
                        onClick: {})
                }
                
                ForEach(template.exercises, id: \.exercise.id.self) { exercise in
                    WorkoutList(type: .exercise, exercise: exercise.exercise, action: {})
                }
                
                BulkUpNavigationLink(
                    text: "Start Workout",
                    destination: WorkoutOngoingView(template: template)
                        .environmentObject(CountDownTimerModel())
                        .environmentObject(CountUpTimerModel())
                        .environmentObject(TimerSettings()),
                    type: .blue,
                    isFullWidth: true,
                    isDisabled: false
                )
                .padding(.top, 20)
                
                Spacer()
            }
            .onAppear {
                viewModel.getTemplateById(templateId: previewTemplateId)
            }
            .padding()
        }
    }
}
