//
//  ExercisesViewSheet.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 13/5/2024.
//

import SwiftUI

struct OngoingExercisesViewSheet: View {
    @StateObject private var viewModel = ExercisesViewModel()
    @ObservedObject private var workoutOngoingViewModel = WorkoutOngoingViewModel()
    @StateObject private var textObserver = TextFieldObserver()
    
    @State var searchQuery = ""
    @State var selectedBodyPart: String = ""
    @State var selectedCategory: String = ""
    @State private var isDialogActive = false
    
    @Binding var isPresented: Bool
    
    var isNewTemplateMode: Bool
    var onAdd: ([DBExercise]) -> Void
    
    let allBodyParts = BodyPart.allCases.map { $0.rawValue.capitalized }
    let allCategories = ExerciseCategory.allCases.map { $0.rawValue.capitalized }
    
    private func filterByBodyPart() {
        Task {
            do {
                try await viewModel.bodyPartFilterSelected(option: selectedBodyPart.isEmpty ? nil : BodyPart(rawValue: selectedBodyPart.lowercased())!)
            } catch {
                print(error)
            }
        }
    }
    
    private func filterByCategory() {
        Task {
            do {
                try await viewModel.categoryFilterSelected(option: selectedCategory.isEmpty ? nil : ExerciseCategory(rawValue: selectedCategory.lowercased())!)
            } catch {
                print(error)
            }
        }
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                if isNewTemplateMode {
                    HStack {
                        Spacer()
                        BulkUpButton(
                            text: "Add",
                            color: .clear,
                            isDisabled: workoutOngoingViewModel.selectedExercises.isEmpty,
                            onClick: {
                                onAdd(workoutOngoingViewModel.selectedExercises)
                                isPresented = false
                            })
                    }
                }
                VStack{
                    TextFieldWithDebounce(debouncedText: $searchQuery)
                        .padding(.bottom, 5)

                    // TODO: Refactor using BodyPartMenu
                    HStack{
                        Menu {
                            Picker("", selection: $selectedBodyPart) {
                                Text("Any Body Part").tag("")
                                ForEach(allBodyParts, id: \.self) { bodyPart in
                                    Text(bodyPart)
                                }
                            }
                            .onChange(of: selectedBodyPart, initial: false, {
                                filterByBodyPart()
                            })
                        } label: {
                            BulkUpButton(text: selectedBodyPart.isEmpty ? "Any Body Part" : selectedBodyPart,
                                         color: !selectedBodyPart.isEmpty ? .blue : .gray,
                                         isDisabled: false, isFullWidth: true) {}
                        }
                        
                        // TODO: Refactor using ExerciseCategoryMenu
                        Menu {
                            Picker("", selection: $selectedCategory) {
                                Text("Any Category").tag("")
                                ForEach(allCategories, id: \.self) { category in
                                    Text(category)
                                }
                            }
                            .onChange(of: selectedCategory, initial: false, {
                                filterByCategory()
                            })
                        } label: {
                            BulkUpButton(text: selectedCategory.isEmpty ? "Any Category" : selectedCategory,
                                         color: !selectedCategory.isEmpty ? .blue : .gray,
                                         isDisabled: false,
                                         isFullWidth: true) {}
                        }
                    }
                }
                .padding()
                
                ScrollView (showsIndicators: true) {
                    ExercisesList(
                        exercises: viewModel.exercises,
                        lastExercise: viewModel.exercises.last,
                        fetchNext: viewModel.getExercises,
                        isReachingEnd: viewModel.isReachingEnd,
                        isNewTemplateMode: isNewTemplateMode,
                        onTap: workoutOngoingViewModel.onExerciseTap
                    )
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button(action: {
                            isDialogActive = true
                        }) {
                            Text("New")
                        }
                    }
                }
            }
            if isDialogActive {
                NewExerciseDialog(isActive: $isDialogActive)
            }
        }
        .task {
            try? await viewModel.getExercises()
        }
        .onChange(of: searchQuery) { _, newValue in
            Task {
                try? await viewModel.searchExercisesByKeyword(query: searchQuery)
            }
        }
    }
}
