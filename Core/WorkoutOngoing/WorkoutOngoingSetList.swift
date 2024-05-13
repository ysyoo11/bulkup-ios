//
//  SetList.swift
//  BulkUp
//
//  Created by Yuta Horiuchi on 9/5/2024.
//

import SwiftUI

struct WorkoutOngoingSetListButton: View {
    
    let text: String
    let foregroundColor: Color
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.headline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

struct WorkoutOngoingSetListTextField: View {
    var placeholder: String = ""
    var foregroundColor: Color
    var backgroundColor: Color
    
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField(placeholder, text: $text)
                    .foregroundColor(foregroundColor)
                    .font(.headline)
                    .focused($isFocused)
                    .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
            }
            .background(backgroundColor)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isFocused ? .primaryGray : .clear, lineWidth: 2)
            )
        }
    }
}


struct WorkoutOngoingSetList: View {

    let exerciseIndex: Int
    let set: Int
    var weight: Double = 0
    var reps: Int = 0
    @State var isChecked: Bool = false
    @Binding var isActiveRestTimerView: Bool
    @EnvironmentObject var timerSettings: TimerSettings
    
    @State var weightStr: String
    @State var repsStr: String
    
    var body: some View {
        HStack{
            WorkoutOngoingSetListButton(
                text: "\(set)",
                foregroundColor: .primaryGray,
                backgroundColor: isChecked ? .secondaryGreen : .secondaryGray,
                action: { print("Tapped") })
            
            if weight > 0 && reps > 0 {
                Text("\(Int(weight))kg x \(reps)")
                    .foregroundColor(.gray)
                    .font(.headline)
                    .frame(width: 150)
            } else {
                Text("-")
                    .foregroundColor(.gray)
                    .font(.headline)
                    .frame(width: 150)
            }
            
            WorkoutOngoingSetListTextField(
                foregroundColor: .primaryGray,
                backgroundColor: isChecked ? .secondaryGreen : .secondaryGray,
                text: $weightStr)
            
            WorkoutOngoingSetListTextField(
                placeholder: "10",
                foregroundColor: .primaryGray,
                backgroundColor: isChecked ? .secondaryGreen : .secondaryGray,
                text: $repsStr)
            
            WorkoutOngoingSetListButton(
                text: "✔︎",
                foregroundColor: isChecked ? .white : .primaryGray,
                backgroundColor: isChecked ? .primaryGreen : .secondaryGray,
                action: {
                    isChecked.toggle()
                    if isChecked {
                        isActiveRestTimerView = true
                    }
                })
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(isChecked ? .secondaryGreen : .clear)
        .onChange(of: isChecked) { oldValue, newValue in
            if newValue && timerSettings.isEnabled {
                isActiveRestTimerView = true
            }
        }
        .onChange(of: weight) { oldValue, newValue in
            weightStr = String(newValue)
        }
        .onChange(of: reps) { oldValue, newValue in
            repsStr = String(newValue)
        }
    }
}
