//
//  ExercisesView.swift
//  BulkUp
//
//  Created by Yuta Horiuchi on 10/5/2024.
//

import SwiftUI
import Combine

class TextFieldObserver : ObservableObject {
    @Published var debouncedText = ""
    @Published var searchText = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] t in
                self?.debouncedText = t
            } )
            .store(in: &subscriptions)
    }
}

@MainActor
final class ExercisesViewModel: ObservableObject {
    
    @Published private(set) var exercises: [DBExercise] = []
    @Published var selectedBodyPart: BodyPart? = nil
    @Published var selectedCategory: ExerciseCategory? = nil
    @Published var searchQuery: String? = ""
     
    func bodyPartFilterSelected(option: BodyPart?) async throws {
        self.selectedBodyPart = option ?? nil
        try await self.getExercises()
    }
    
    func categoryFilterSelected(option: ExerciseCategory?) async throws {
        self.selectedCategory = option ?? nil
        try await self.getExercises()
    }
    
    func searchExercisesByKeyword(query: String) async throws {
        self.searchQuery = query
        try await self.getExercises()
    }
    
    func getExercises() async throws {
        self.exercises = try await ExercisesManager.shared.getExercises(bodyPart: selectedBodyPart, category: selectedCategory, query: searchQuery)
    }
}

struct ExercisesView: View {
    @StateObject private var viewModel = ExercisesViewModel()
    @StateObject private var textObserver = TextFieldObserver()
    
    @State var searchQuery = ""
    @State var selectedBodyPart: String = ""
    @State var selectedCategory: String = ""
    @State private var isDialogActive = false
    
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
                    ExercisesList(exercises: viewModel.exercises)
                }
                .navigationTitle("Exercises")
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

struct ExercisesList: View {
    
    let exercises: [DBExercise]
    
    var body: some View {
        VStack (spacing: 0) {
            ForEach(sections.keys.sorted(), id: \.self) { key in
                VStack (alignment: .leading) {
                    Text(key)
                        .padding(.top)
                        .padding(.leading)
                        .font(Font.system(size: 14))
                        .foregroundColor(Color.gray)
                    Divider()
                }
                ForEach(sections[key]!, id: \.id) { exercise in
                    WorkoutList(type: .exercise,
                                name: exercise.name,
                                category: exercise.category.rawValue,
                                bodyPart: exercise.bodyPart.rawValue,
                                imageUrl: exercise.imageUrl,
                                action: {print(exercise.name)}) // TODO: Show modal view
                    Divider()
                        .padding(.horizontal, 15)
                }
            }
        }
    }
    
    func prepareData(exercises: [DBExercise]) -> [String: [DBExercise]] {
        let sortedExercises = exercises.sorted { $0.name < $1.name }
        let grouped = Dictionary(grouping: sortedExercises) { String($0.name.prefix(1)) }
        return grouped
    }
            
    private var sections: [String: [DBExercise]] {
        prepareData(exercises: exercises)
    }
}

#Preview {
    ExercisesView()
}
