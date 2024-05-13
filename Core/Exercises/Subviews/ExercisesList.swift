//
//  ExercisesList.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 12/5/2024.
//

import SwiftUI

struct ExercisesList: View {
    
    let exercises: [DBExercise]
    var lastExercise: DBExercise?
    let fetchNext: @MainActor () async throws -> ()
    var isReachingEnd: Bool
    var isNewTemplateMode: Bool
    var onTap: @MainActor (DBExercise) -> ()
    
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
                                exercise: exercise,
                                action: {
                                    onTap(exercise)
                                }, // TODO: Show modal view
                                isNewTemplateMode: isNewTemplateMode)
                    
                    Divider()
                        .padding(.horizontal, 15)
                    
                    if exercise == lastExercise && !isReachingEnd {
                        ProgressView()
                            .onAppear {
                                Task {
                                    do {
                                        try await fetchNext()
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                            .padding(.vertical, 20)
                    }
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
