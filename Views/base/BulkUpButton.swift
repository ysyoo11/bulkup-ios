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
    var imageResource: ImageResource?
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            HStack(spacing: 10, content: {
                if let imageResource = imageResource {
                    Image(imageResource)
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .trailing)
                }
                Text(text)
                    .foregroundColor(color.textColor)
                    .bold()
            })
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
        }
        .disabled(isDisabled)
        .background(color.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .opacity(isDisabled ? 0.6 : 1.0)
    }
}

#Preview {
    VStack {
        BulkUpButton(text: "Sign In with Google", color: .gray, isDisabled: false, isFullWidth: true, imageResource: .googleLogo) {
            print("Cancel")
        }
        HStack {
            BulkUpButton(text: "Cancel", color: .gray, isDisabled: false, isFullWidth: true) {
                print("Cancel")
            }
            BulkUpButton(text: "Save", color: .blue, isDisabled: false, isFullWidth: true) {
                print("Save")
            }
        }
    }
    .padding()
}
