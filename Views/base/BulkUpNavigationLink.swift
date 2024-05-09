//
//  BulkUpNavigationLink.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 8/5/2024.
//

import SwiftUI

enum LinkType {
    case noBorder, blue, green

    var backgroundColor: Color {
        switch self {
        case .noBorder: return .clear
        case .blue: return .primaryBlue
        case .green: return .primaryGreen
        }
    }

    var textColor: Color {
        switch self {
        case .noBorder: return .primaryBlue
        case .blue, .green: return .white
        }
    }
}

struct BulkUpNavigationLink<Destination: View>: View {
    let text: String
    let destination: Destination
    var type: LinkType
    var isFullWidth: Bool = false
    @State var isDisabled: Bool
    
    var body: some View {
        NavigationLink(destination: destination) {
            Text(text)
                .foregroundColor(type.textColor)
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .bold()
                .background(type.backgroundColor)
                .cornerRadius(6)
                .opacity(isDisabled ? 0.6 : 1.0)
                .underline()
        }
        .disabled(isDisabled)
    }
}

#Preview {
    NavigationView {
        VStack {
            BulkUpNavigationLink(
                text: "Finish",
                destination: SignUpView(showWelcomeView: .constant(true)),
                type: .green,
                isFullWidth: false,
                isDisabled: false
            )
            BulkUpNavigationLink(
                text: "Sign Up",
                destination: SignUpView(showWelcomeView: .constant(true)),
                type: .blue,
                isFullWidth: true,
                isDisabled: false
            )
            BulkUpNavigationLink(
                text: "Log in",
                destination: LogInView(),
                type: .noBorder,
                isFullWidth: true,
                isDisabled: false
            )
        }
        .padding()
    }
}
