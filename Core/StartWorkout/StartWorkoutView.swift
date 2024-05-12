//
//  StartWorkoutView.swift
//  BulkUp
//
//  Created by Eunbyul Cho on 9/5/2024.
//

import SwiftUI

@MainActor
final class StartWorkoutViewModel: ObservableObject {
    
    @Published private(set) var templates: [UserTemplateWithExercises] = []
    
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
                let userTemplates = try await UserManager.shared.getAllUserTemplates(userId: authDataResult.uid)
                
                var templatesArr: [UserTemplateWithExercises] = []
                for userTemplate in userTemplates {
                    var exerciseArr: [UserTemplateExerciseWithExercise] = []
                    for exercise in userTemplate.exercises {
                        let dbExercise = try await ExercisesManager.shared.getExerciseById(exerciseId: exercise.exerciseId)
                        exerciseArr.append(UserTemplateExerciseWithExercise(exercise: dbExercise, sets: exercise.sets))
                    }
                    templatesArr.append(UserTemplateWithExercises(id: userTemplate.id, name: userTemplate.name, exercises: exerciseArr, createdAt: userTemplate.createdAt, updatedAt: userTemplate.updatedAt))
                }
                
                print(templatesArr)
                
                self.templates = templatesArr
            } catch {
                print(error)
            }
        }
    }
    
}

struct StartWorkoutView: View {
    @StateObject var viewModel = StartWorkoutViewModel()
    
    @State private var userTemplates: [UserTemplate] = []
    @State private var showingNewTemplate = false  // State to control the modal presentation
    
//    let exampleTemplates: [UserTemplate] = [
//        UserTemplate(id: "1", name: "Legs A", exercises: ExerciseDatabase.exercises.filter({ exercise in
//            exercise.bodyPart == .legs
//        }), createdAt: Date(), updatedAt: Date()),
//        UserTemplate(id: "2", name: "Chest A", exercises: ExerciseDatabase.exercises.filter({ exercise in
//            exercise.bodyPart == .chest
//        }), createdAt: Date(), updatedAt: Date())
//    ]
    
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
                        ForEach(viewModel.templates, id: \.id) { template in
                            TemplateCard(template: template)
                        }
                        NewTemplateCard(onClick: {
                            showingNewTemplate = true
                        })
                    }
                
                
//                Section() {
//                    HStack {
//                        Text("Example Templates (\(exampleTemplates.count))")
//                            .font(.headline)
//                            .bold()
//                    }
//                    LazyVGrid(columns: adaptiveColumns, spacing: 20) {
//                        ForEach(exampleTemplates, id: \.id) { template in
//                            TemplateCard(template: template)
//                        }
//                    }
//                }

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

struct TemplateCard: View {
    var template: UserTemplateWithExercises

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(template.name)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                TemplateEditMenu()
            }
            ForEach(template.exercises, id: \.exercise.id) { exerciseWithSets in
                Text("\(exerciseWithSets.exercise.name) (\(exerciseWithSets.exercise.category))")
                    .font(.subheadline)
                    .foregroundColor(.primaryGray)
            }
            Spacer()
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius:10)
                .stroke(.secondaryGray, lineWidth: 1)
                .frame(minWidth: 170, minHeight: 140, maxHeight: 140))
        .frame(minWidth: 170, maxHeight: 160)
    }
}

struct NewTemplateCard: View {
    var onClick: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            BulkUpButton(text: "Tap to Add New Template", color: .clear, isDisabled: false, onClick: onClick)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius:10)
                .stroke(.secondaryGray, lineWidth: 1)
                .frame(minWidth: 170, minHeight: 140, maxHeight: 140))
        .frame(minWidth: 170, minHeight: 140, maxHeight: 140)

    }
}

#Preview {
    StartWorkoutView()
}
