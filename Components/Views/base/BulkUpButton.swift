//
//  BulkUpButton.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 6/5/2024.
//

import SwiftUI

enum ButtonColor {
    case blue, red, green, skyblue, pink, gray, clear

    var backgroundColor: Color {
        switch self {
        case .blue: return .primaryBlue
        case .red: return .primaryRed
        case .green: return .primaryGreen
        case .skyblue: return .secondaryBlue
        case .pink: return .secondaryRed
        case .gray: return .secondaryGray
        case .clear: return .clear
        }
    }

    var textColor: Color {
        switch self {
        case .blue, .red, .green: return .white
        case .skyblue: return .primaryBlue
        case .pink: return .primaryRed
        case .gray: return .primaryGray
        case .clear: return .primaryBlue
        }
    }
}

enum ButtonSize {
    case xs, sm, base, lg
    
    var fontSize: CGFloat {
        switch self {
        case .xs: return 12
        case .sm: return 14
        case .base: return 16
        case .lg: return 24
        }
    }
    
    var verticalPaddingSize: CGFloat {
        switch self {
        case.xs: return 4
        case .sm: return 6
        case .base: return 8
        case .lg: return 10
        }
    }
}

struct BulkUpButton: View {
    let text: String
    let color: ButtonColor
    var isDisabled: Bool
    var isFullWidth: Bool = false
    var imageResource: ImageResource?
    var image: Image?
    var size: ButtonSize? = .base
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            HStack(content: {
                if let imageResource = imageResource {
                    Image(imageResource)
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .trailing)
                        .padding(.trailing, 10)
                }
                if let image {
                    image.resizable().frame(width: 15, height: 15)
                }
                Text(text)
                    .foregroundColor(color.textColor)
                    .bold()
                    .underline()
                    .font(.system(size: size?.fontSize ?? 16))
            })
            .padding(.horizontal, 10)
            .padding(.vertical, size?.verticalPaddingSize ?? 8)
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
        BulkUpButton(text: "Template", color: .skyblue, isDisabled: false, image: Image(systemName: "plus")) {
            print("")
        }
    }
    .padding()
}
