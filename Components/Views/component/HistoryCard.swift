//
//  HistoryCard.swift
//  BulkUp
//
//  Created by Eunbyul Cho on 8/5/2024.
//

import SwiftUI

struct HistoryCardBuilder: View {
    
    let historyId: String
    @State private var history: UserHistoryWithInfo? = nil
    @Binding var selectedHistoryId: String
    @Binding var showingHistoryDetail: Bool
    
    var body: some View {
        ZStack {
            if let history {
                HistoryCard(history: history)
            }
        }
        .task {
            do {
                let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
                let userHistory = try await UserManager.shared.getUserHistoryById(userId: authDataResult.uid, historyId: historyId)
                let template = try await UserManager.shared.getUserTemplateById(userId: authDataResult.uid, templateId: userHistory.templateId)
                
                var exerciseArr: [UserTemplateExerciseWithExercise] = []
                for exercise in template.exercises {
                    if let dbExercise = try? await ExercisesManager.shared.getExerciseById(exerciseId: exercise.exerciseId) {
                        exerciseArr.append(UserTemplateExerciseWithExercise(exercise: dbExercise, sets: exercise.sets))
                    }
                }
                
                self.history = UserHistoryWithInfo(
                    id: userHistory.id,
                    template: UserTemplateWithExercises(
                        id: template.id,
                        name: template.name,
                        exercises: exerciseArr,
                        createdAt: template.createdAt,
                        updatedAt: template.updatedAt),
                    duration: userHistory.duration,
                    volume: userHistory.volume,
                    createdAt: userHistory.createdAt,
                    updatedAt: userHistory.updatedAt)
            } catch {
                print(error)
            }
        }
    }
}

struct HistoryCard: View {
    var history: UserHistoryWithInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    Text(history.template.name)
                        .bold()
                    Text(history.createdAt ?? Date(), style: .date)
                        .font(.subheadline)
                    
                }
                Spacer()
                HistoryEditMenu()
                    .contentShape(Rectangle())
                    .frame(width: 55, height: 44)
            }

            HStack {
                Image(systemName: "clock")
                Text("\(history.duration) min")
        
                Image(systemName: "scalemass")
                Text("\(history.volume) kg")
            }
            .font(.caption)

            
            HStack {
                Text("Exercise")
                    .font(Font.system(size: 15))
                    .fontWeight(.medium)
                    .frame(alignment: .leading)
                    .foregroundStyle(.primaryGray)
                Spacer()
                Text("Best Set")
                    .font(Font.system(size: 15))
                    .fontWeight(.medium)
                    .frame(alignment: .leading)
                    .foregroundStyle(.primaryGray)
                Spacer()
            }
            
            VStack {
                ForEach(Array(history.template.exercises.enumerated()), id: \.element.exercise.id.self) { _, exercise in
                    HStack {
                        VStack {
                            Text("\(exercise.sets.count) x \(exercise.exercise.name) (\(exercise.exercise.category))")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                                .frame(alignment: .leading)
                        }
                        .frame(
                          minWidth: 0,
                          maxWidth: .infinity,
                          minHeight: 0,
                          alignment: .topLeading
                        )
                        VStack {
                            Text("\(Int(exercise.sets[0].weight!))kg x \(exercise.sets[0].reps)")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                                .frame(alignment: .leading)
                        }
                        .frame(
                          minWidth: 0,
                          maxWidth: .infinity,
                          minHeight: 0,
                          alignment: .topLeading
                        )
                    }
                    
                }
            }
        }
        .padding([.leading, .top, .bottom])
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 1)
        .padding(.horizontal, 10)
    }
}

var tempHistory: UserHistoryWithInfo = UserHistoryWithInfo(
    id: "1",
    template: UserTemplateWithExercises(id: "1", name: "Template A", exercises: [], createdAt: Date(), updatedAt: Date()),
    duration: 100,
    volume: 1000,
    createdAt: Date() - 1000,
    updatedAt: Date() - 1000
)

#Preview {
    HistoryCard(history: tempHistory)
}
