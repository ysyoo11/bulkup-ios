//
//  WorkoutList.swift
//  BulkUp
//
//  Created by Yuta Horiuchi on 7/5/2024.
//

import SwiftUI

enum WorkoutListType: String {
    case exercise = "exercise"
    case newTemplate = "newTemplate"
}

struct WorkoutList: View {
    let type: WorkoutListType
    let exercise: DBExercise
    let action: () -> Void
    
    var isNewTemplateMode: Bool = false
    
    var count: Int = 0
    var weight: Double = 0
    var reps: Int = 0
    
    @State private var isSelected: Bool = false
    
    var body: some View {
        
            HStack {
                AsyncImage(url: URL(string: exercise.imageUrl ?? "")){ image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } placeholder: {
                    ProgressView()
                }
                    .frame(width: 30, height:30)
                    
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(exercise.name) (\(exercise.category.rawValue.capitalized))")
                        .font(.headline)
                    HStack{
                        Text(exercise.bodyPart.rawValue.capitalized)
                        Spacer()
                        if type == .exercise {
                            if weight > 0 && reps > 0 {
                                Text("\(Int(weight)) kg (x\(reps))")
                                    .padding(.trailing, 20)
                            }
                        } else {
                            if count > 0 {
                                Text("\(count)")
                            }
                        }
                    }
                    .foregroundColor(.gray)
                }
                if type == .newTemplate {
                    Button(action: isSelected ? { isSelected.toggle() } : { action() }) {
                        Image(systemName: isSelected ? "checkmark" : "questionmark")
                            .resizable()
                            .frame(width: 10, height: 15)
                            .foregroundColor(.primaryBlue)
                            .font(.body)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(.secondaryBlue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .padding(.trailing, 10)
            .background(isSelected && isNewTemplateMode ? Color.secondaryBlue : Color.white)
            .onTapGesture(perform: {
                isSelected.toggle()
                if type == .exercise {
                    action()
                }
            })
        }
    
}
