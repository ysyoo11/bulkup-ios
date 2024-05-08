//
//  ExerciseList.swift
//  BulkUp
//
//  Created by Yuta Horiuchi on 7/5/2024.
//

import SwiftUI

enum ExerciseListType: String {
    case exercise = "exercise"
    case newTemplate = "newTemplate"
}

struct ExerciseList: View {
    let type: ExerciseListType
    let name: String
    let exerciseType: String
    let bodyPart: String
    let imageUrl: String
    let action: () -> Void
    
    var count: Int = 0
    var weight: Double = 0
    var reps: Int = 0
    
    @State private var isSelected: Bool = false
    
    var body: some View {
        
            HStack {
                AsyncImage(url: URL(string: imageUrl))
                    
                        .scaledToFit()
                        .frame(width: 30)
                        .padding(.trailing, 5)
                    
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(name) (\(exerciseType))")
                        .font(.headline)
                    HStack{
                        Text(bodyPart)
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
            .background(isSelected ? Color.secondaryBlue : Color.white)
            .onTapGesture(perform: {
                isSelected.toggle()
                if type == .exercise {
                    action()
                }
            })
        }
    
}


#Preview {
    VStack (spacing: 0){
        ExerciseList(type: .exercise,
                name: "Squat",
                exerciseType: "Barbell",
                bodyPart: "Legs",
                imageUrl: "",
                action: { print("SetList tapped") })
        ExerciseList(type: .exercise,
                name: "Squat",
                exerciseType: "Barbell",
                bodyPart: "Legs",
                imageUrl: "",
                action: { print("SetList tapped") },
                weight: 60.0,
                reps: 10)
        
        Text("SetList for NewTemplate View")
            .font(.headline)
            .padding()
        ExerciseList(type: .newTemplate,
                name: "Bench Press",
                exerciseType: "Dumbbell",
                bodyPart: "Chest",
                imageUrl: "",
                action: { print("Questionmark is tapped") })
        ExerciseList(type: .newTemplate,
                name: "Bench Press",
                exerciseType: "Dumbbell",
                bodyPart: "Chest",
                imageUrl: "",
                action: { print("Questionmark is tapped") },
                count: 1)
    }
}
