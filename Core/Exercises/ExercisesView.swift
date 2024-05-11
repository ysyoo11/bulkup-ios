//
//  ExercisesView.swift
//  BulkUp
//
//  Created by Yuta Horiuchi on 10/5/2024.
//

import SwiftUI

@MainActor
final class ExercisesViewModel: ObservableObject {
    
    @Published private(set) var exercises: [DBExercise] = []
    
    func getAllExercises() async throws {
        self.exercises = try await ExercisesManager.shared.getAllExercises()
    }
    
}

struct ExercisesView: View {
    @StateObject private var viewModel = ExercisesViewModel()
    
    @State private var isSearchActive: Bool = false
    @State private var searchText: String = ""
    @State private var isDialogActive = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack{
//                    BulkUpTextField(placeholder: "Search", type: .light, isSearch: true)
                    HStack{
                        BodyPartMenu()
                        ExerciseCategoryMenu()
                    }
                }
                .padding()
                
                ScrollView (showsIndicators: true) {
                    if isSearchActive {
                        FilteredList(exercises: ExerciseDatabase.exercises.filter { $0.name.localizedCaseInsensitiveContains(searchText) })
                    } else {
                        AlphabeticalList(exercises: ExerciseDatabase.exercises)
                    }
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
            try? await viewModel.getAllExercises()
        }
    }
}

struct AlphabeticalList: View {
    
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

struct FilteredList: View {
    
    let exercises: [DBExercise]
    
    var body: some View {
        VStack (spacing: 0) {
            Divider()
            ForEach(prepareData(exercises: exercises), id: \.name) { exercise in
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
    
    func prepareData(exercises: [DBExercise]) -> [DBExercise] {
        let sortedExercises = exercises.sorted { $0.name < $1.name }
        return sortedExercises
    }
}

#Preview {
    ExercisesView()
}
