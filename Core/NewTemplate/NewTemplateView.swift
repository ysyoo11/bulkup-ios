//
//  NewTemplateView.swift
//  BulkUp
//
//  Created by Eunbyul Cho on 9/5/2024
//

import SwiftUI

struct NewTemplateView: View {
    
    @StateObject private var viewModel = NewTemplateViewModel()
    
    @Binding var isPresented: Bool
    @State private var showingRestTimerSetupView: Bool = false
    @State private var showingExercisesView: Bool = false
    @State private var selectedExerciseIndex: Int = 0
    @State private var selectedExercise: UserTemplateExerciseWithExercise?
    @State private var currentStagedExercises: [UserTemplateExerciseWithExercise] = []
    
    private func onAdd(exercises: [DBExercise]) {
        viewModel.stageSelectedExercises(exercises: exercises)
        showingExercisesView = false
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .imageScale(.large)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Text("New Template")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    BulkUpButton(
                        text: "Save",
                        color: .blue,
                        isDisabled: viewModel.stagedExercises.isEmpty || viewModel.templateName.isEmpty,
                        onClick: {
                            viewModel.addUserTemplate()
                            isPresented = false
                    })
                }
                .padding(.horizontal, 10)
                
                ScrollView {
                    BulkUpTextField(placeholder: "Template name", type: .noBorder, size: .lg, text: $viewModel.templateName)
                        .padding(.horizontal, 10)
                    
                    VStack {
                        ForEach(Array(viewModel.stagedExercises.enumerated()), id: \.offset) { exerciseIdx, item in
                            VStack {
                                HStack {
                                    Text("\(item.exercise.name) (\(item.exercise.category.rawValue.capitalized))")
                                        .font(.headline)
                                        .foregroundStyle(.primaryBlue)
                                        .underline()
                                    
                                    Spacer()
                                    
                                    BulkUpButton(text: "Timer", color: .clear, isDisabled: false, onClick: {
                                        currentStagedExercises = viewModel.stagedExercises
                                        selectedExerciseIndex = exerciseIdx
                                        selectedExercise = item
                                        showingRestTimerSetupView = true
                                    })
                                    BulkUpMenu(options: [
                                        .option(text: "Remove Exercise", icon: "xmark", action: {
                                            viewModel.removeExercise(index: exerciseIdx, from: viewModel.stagedExercises)
                                        })
                                    ])
                                }
                                VStack(spacing: 5) {
                                    HStack {
                                        Text("Set")
                                            .font(Font.system(size: 15))
                                            .fontWeight(.bold)
                                        Spacer()
                                        Text("Previous")
                                            .font(Font.system(size: 15))
                                            .fontWeight(.bold)
                                        Spacer()
                                        Text("kg")
                                            .font(Font.system(size: 15))
                                            .fontWeight(.bold)
                                        Spacer()
                                        Text("Reps")
                                            .font(Font.system(size: 15))
                                            .fontWeight(.bold)
                                        Spacer()
                                        Text("-")
                                            .font(Font.system(size: 15))
                                            .fontWeight(.bold)
                                    }
                                    .padding(.horizontal)
                                    
                                    ForEach(Array(item.sets.enumerated()), id: \.offset) { offset, set in
                                        SetList(
                                            exerciseIdx: exerciseIdx,
                                            offset: offset,
                                            type: .edit, 
                                            onDelete: {
                                                viewModel.removeSet(index: offset, stagedExercises: viewModel.stagedExercises)
                                            },
                                            updateSet: viewModel.updateSet
                                        )
                                    }
                                    BulkUpButton(text: "+ Add Set", color: .gray, isDisabled: false, isFullWidth: true, size: .sm, onClick: {
                                        viewModel.addSet(index: exerciseIdx, stagedExercises: viewModel.stagedExercises)
                                    })
                                }
                            }
                            .padding(.bottom, 20)
                        }
                        BulkUpButton(text: "Add Exercises", color: .skyblue, isDisabled: false, isFullWidth: true, onClick: {
                            showingExercisesView = true
                        })
                        .padding(.top, 10)
                    }
                    .padding(.top, 30)
                    .padding(.horizontal, 20)
                }

                Spacer()
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingExercisesView) {
                ExercisesViewSheet(isPresented: $showingExercisesView, isNewTemplateMode: true, onAdd: onAdd)
            }
            .sheet(isPresented: $showingRestTimerSetupView) {
                RestTimerSetupView(
                    exerciseIndex: $selectedExerciseIndex,
                    exercise: $selectedExercise,
                    currentStagedExercises: $currentStagedExercises)
            }
        }
    }
}

struct NewTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        NewTemplateView(isPresented: .constant(true))
    }
}
