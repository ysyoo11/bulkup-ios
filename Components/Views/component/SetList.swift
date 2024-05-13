//
//  SetList.swift
//  BulkUp
//
//  Created by Yuta Horiuchi on 9/5/2024.
//

import SwiftUI

struct SetListButton: View {
    
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

struct SetListTextField: View {
    var placeholder: String = ""
    var foregroundColor: Color
    var backgroundColor: Color
    
    @State private var text: String = ""
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

enum SetListType {
    case edit
    case ongoing
}

struct SetList: View {
    let set: Int
    var weight: Double = 0
    var reps: Int = 0
    let type: SetListType
    var onDelete: () -> Void
    @State private var isChecked: Bool = false
    
    var body: some View {
        HStack{
            SetListButton(text: "\(set)",
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
            SetListTextField(foregroundColor: .primaryGray,
                             backgroundColor: isChecked ? .secondaryGreen : .secondaryGray)
            SetListTextField(placeholder: "10",
                             foregroundColor: .primaryGray,
                             backgroundColor: isChecked ? .secondaryGreen : .secondaryGray)
            SetListButton(text: type == .ongoing ? "✔︎" : "ⅹ",
                      foregroundColor: isChecked ? .white : .primaryGray,
                      backgroundColor: isChecked ? .primaryGreen : .secondaryGray,
                      action: {
                type == .ongoing ? isChecked.toggle() : onDelete()
                        })
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(isChecked ? .secondaryGreen : .clear)
    }
}

#Preview {
    VStack(spacing: 0){
        SetList(set: 1, weight: 50.0, reps: 10, type: .edit, onDelete: {})
        SetList(set: 2, weight: 55.0, reps: 10, type: .ongoing, onDelete: {})
        SetList(set: 3, type: .edit, onDelete: {})
    }
}
