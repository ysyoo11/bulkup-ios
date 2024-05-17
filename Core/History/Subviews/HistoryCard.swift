//
//  HistoryCard.swift
//  BulkUp
//
//  Created by Eunbyul Cho on 8/5/2024.
//

import SwiftUI

struct HistoryCard: View {
    @ObservedObject private var viewModel = HistoryViewModel()
    var history: UserHistoryWithInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack {
                HStack {
                    Text(history.template.name)
                        .bold()
                    
                    Spacer()
                    BulkUpMenu(options: [
                        .option(text: "Delete", icon: "xmark", action: {
                            viewModel.deleteHistory(historyId: history.id)
                        })
                    ])
                }
                HStack {
                    Text(history.createdAt!, style: .date)
                        .font(.subheadline)
                    Spacer()
                }

                HStack {
                    Image(systemName: "clock")
                    Text("\(history.duration) min")
            
                    Image(systemName: "scalemass")
                    Text("\(history.volume) kg")
                    
                    Spacer()
                }
                .font(.caption)
                .padding(.top, 1)
                
//                VStack {
//                    HStack {
//                        Text("Exercise")
//                            .font(Font.system(size: 15))
//                            .fontWeight(.medium)
//                            .foregroundStyle(.primaryGray)
//                            .frame(
//                              minWidth: 0,
//                              maxWidth: .infinity,
//                              minHeight: 0,
//                              alignment: .topLeading
//                            )
//                        
//                        Text("Best Set")
//                            .font(Font.system(size: 15))
//                            .fontWeight(.medium)
//                            .foregroundStyle(.primaryGray)
//                            .frame(
//                              minWidth: 0,
//                              maxWidth: .infinity,
//                              minHeight: 0,
//                              alignment: .topLeading
//                            )
//                    }
//                    .padding(.top, 2)
//                    
//                    ForEach(Array(history.template.exercises.enumerated()), id: \.element.exercise.id.self) { _, exercise in
//                        HStack {
//                            Text("\(exercise.sets.count) x \(exercise.exercise.name) (\(exercise.exercise.category))")
//                                .font(.footnote)
//                                .foregroundStyle(.gray)
//                                .frame(
//                                  minWidth: 0,
//                                  maxWidth: .infinity,
//                                  minHeight: 0,
//                                  alignment: .topLeading
//                                )
//                                .lineLimit(1)
//                                .truncationMode(.tail)
//
//                            Text("\(Int(exercise.sets[0].weight!))kg x \(exercise.sets[0].reps)")
//                                .font(.footnote)
//                                .foregroundStyle(.gray)
//                                .frame(
//                                  minWidth: 0,
//                                  maxWidth: .infinity,
//                                  minHeight: 0,
//                                  alignment: .topLeading
//                                )
//                                .lineLimit(1)
//                                .truncationMode(.tail)
//                        }
//                    }
//                }
//                .padding(.top, 1)
            }
            .padding()
        }
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 1)
        .padding(.horizontal)
    }
}

var tempHistory: UserHistoryWithInfo = UserHistoryWithInfo(
    id: "1",
    template: UserTemplateWithExercises(id: "1", name: "Template A", exercises: [UserTemplateExerciseWithExercise(exercise: DBExercise(id: "1", name: "Deadlift", bodyPart: .fullBody, category: .barbell, description: "Deadlift", imageUrl: ""), sets: [WorkoutSet(weight: 140, reps: 10)])], createdAt: Date(), updatedAt: Date()),
    duration: 100,
    volume: 1000,
    createdAt: Date() - 1000,
    updatedAt: Date() - 1000
)

#Preview {
    HistoryCard(history: tempHistory)
}
