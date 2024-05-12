//
//  StartWorkoutView.swift
//  BulkUp
//
//  Created by Eunbyul Cho on 9/5/2024.
//

import SwiftUI

@MainActor
final class StartWorkoutViewModel: ObservableObject {
    
    @Published private(set) var templates: [UserTemplate] = []
    
    func addUserTemplate(template: UserTemplate) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.addUserTemplate(userId: authDataResult.uid, template: template)
        }
    }
    
    func getUserTemplates() {
        Task {
            do {
                let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
                self.templates = try await UserManager.shared.getAllUserTemplates(userId: authDataResult.uid)
//                let userTemplates = try await UserManager.shared.getAllUserTemplates(userId: authDataResult.uid)
//                
//                var templatesArr: [UserTemplateWithExercises] = []
//                for userTemplate in userTemplates {
//                    var exerciseArr: [UserTemplateExerciseWithExercise] = []
//                    for exercise in userTemplate.exercises {
//                        if let dbExercise = try? await ExercisesManager.shared.getExerciseById(exerciseId: exercise.exerciseId) {
//                            exerciseArr.append(UserTemplateExerciseWithExercise(exercise: dbExercise, sets: exercise.sets))
//                        }
//                    }
//                    templatesArr.append(UserTemplateWithExercises(id: userTemplate.id, name: userTemplate.name, exercises: exerciseArr, createdAt: userTemplate.createdAt, updatedAt: userTemplate.updatedAt))
//                }
//                
//                self.templates = templatesArr
            } catch {
                print(error)
            }
        }
    }
    
    func removeUserTemplate(templateId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserTemplate(userId: authDataResult.uid, templateId: templateId)
        }
    }
    
}

struct StartWorkoutView: View {
    @StateObject var viewModel = StartWorkoutViewModel()
    
    @State private var userTemplates: [UserTemplate] = []
    @State private var showingNewTemplate = false  // State to control the modal presentation
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 170))
    ]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Section(header: Text("Quick Start").font(.headline).bold().padding(.top, 40)) {
                    BulkUpButton(
                        text: "Start an Empty Workout",
                        color: .blue,
                        isDisabled: false,
                        isFullWidth: true,
                        onClick: {
                            print("Start an empty workout tapped")
                        })
                }

                HStack {
                    Text("Templates")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    BulkUpButton(
                        text: "Template",
                        color: .skyblue,
                        isDisabled: false,
                        image: Image(systemName: "plus")
                    ) {
                        showingNewTemplate = true
                    }
                }
                
                
                HStack {
                    Text("My Templates (\(viewModel.templates.count))")
                        .font(.headline)
                        .bold()
                }
                LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                    ForEach(viewModel.templates, id: \.id.self) { template in
                        TemplateCardViewBuilder(templateId: template.id)
                    }
                    NewTemplateCard(onClick: {
                        showingNewTemplate = true
                    })
                }

                Spacer()
            }
            .navigationTitle("Start Workout")
            .sheet(isPresented: $showingNewTemplate) {
                NewTemplateView(isPresented: $showingNewTemplate)
            }
            .padding(.horizontal, 20)
            .task {
                viewModel.getUserTemplates()
            }
        }
    }
}
    
#Preview {
    StartWorkoutView()
}

