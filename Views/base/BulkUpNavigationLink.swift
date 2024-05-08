//
//  BulkUpNavigationLink.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 8/5/2024.
//

import SwiftUI

struct BulkUpNavigationLink<Destination: View>: View {
    let text: String
    let destination: Destination
    var isFullWidth: Bool = false
    @State var isDisabled: Bool
    
    var body: some View {
        NavigationLink(destination: destination) {
            Text(text)
                .foregroundColor(.white)
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .bold()
                .background(.primaryBlue)
                .cornerRadius(6)
                .opacity(isDisabled ? 0.6 : 1.0)
        }
        .disabled(isDisabled)
    }
}

#Preview {
    VStack {
        NavigationView {
            BulkUpNavigationLink(
                text: "Sign Up",
                destination: SignUpView(),
                isFullWidth: true,
                isDisabled: false
            )
        }
    }
    .padding()
}
