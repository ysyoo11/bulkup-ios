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

enum SetListType {
    case edit
    case ongoing
}

struct SetList: View {
    
    let exerciseIdx: Int
    let offset: Int
    let type: SetListType
    var onDelete: () -> Void
    var updateSet: @MainActor (Int, Int, Double?, Int?) -> ()
    
    @State private var isChecked: Bool = false
    @State private var weightStr: String = "0"
    @State private var repsStr: String = "0"
    
    var body: some View {
        HStack{
            SetListButton(
                text: "\(offset + 1)",
                foregroundColor: .primaryGray,
                backgroundColor: isChecked ? .secondaryGreen : .secondaryGray,
                action: { print("Tapped") })

            Text("-")
                .foregroundColor(.gray)
                .font(.headline)
                .frame(width: 150)
            
            SetListTextField(
                foregroundColor: .primaryGray,
                backgroundColor: isChecked ? .secondaryGreen : .secondaryGray,
                text: $weightStr)
            
            SetListTextField(
                foregroundColor: .primaryGray,
                backgroundColor: isChecked ? .secondaryGreen : .secondaryGray,
                text: $repsStr)
            
            SetListButton(
                text: type == .ongoing ? "✔︎" : "ⅹ",
                foregroundColor: isChecked ? .white : .primaryGray,
                backgroundColor: isChecked ? .primaryGreen : .secondaryGray,
                action: {
                    type == .ongoing ? isChecked.toggle() : onDelete()
                })
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(isChecked ? .secondaryGreen : .clear)
        .onChange(of: weightStr) {
            updateSet(
                exerciseIdx,
                offset,
                Double(weightStr),
                Int(repsStr))
        }
        .onChange(of: repsStr) {
            updateSet(
                exerciseIdx,
                offset,
                Double(weightStr),
                Int(repsStr))
        }
    }
}
