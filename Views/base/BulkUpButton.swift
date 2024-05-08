//
//  BulkUpButton.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 6/5/2024.
//

import SwiftUI

enum ButtonColor {
    case blue, red, green, skyblue, pink, gray

    var backgroundColor: Color {
        switch self {
        case .blue: return .primaryBlue
        case .red: return .primaryRed
        case .green: return .primaryGreen
        case .skyblue: return .secondaryBlue
        case .pink: return .secondaryRed
        case .gray: return .secondaryGray
        }
    }

    var textColor: Color {
        switch self {
        case .blue, .red, .green: return .white
        case .skyblue: return .primaryBlue
        case .pink: return .primaryRed
        case .gray: return .primaryGray
        }
    }
}


struct BulkUpButton: View {
    let text: String
    let color: ButtonColor
    var isDisabled: Bool
    var isFullWidth: Bool = false
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            Text(text)
                .foregroundColor(color.textColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .bold()
                .frame(maxWidth: isFullWidth ? .infinity : nil)
        }
        .disabled(isDisabled)
        .background(color.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    HStack {
        BulkUpButton(text: "Cancel", color: .gray, isDisabled: false, isFullWidth: true) {
            print("Cancel")
        }
        BulkUpButton(text: "Save", color: .blue, isDisabled: false, isFullWidth: true) {
            print("Save")
        }
    }
    .padding()
}
