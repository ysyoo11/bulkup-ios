//
//  LogInView.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 8/5/2024.
//

import SwiftUI

struct LogInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    // TODO:
    private func logIn() {
        print("Log In tapped")
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(.welcome)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .blur(radius: 10)
                
                Rectangle()
                    .opacity(0.6)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Log In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    BulkUpTextField(
                        placeholder: "",
                        type: .dark,
                        label: "Email Address",
                        size: .sm
                    )
                    
                    BulkUpTextField(
                        placeholder: "",
                        type: .dark,
                        label: "Password",
                        size: .sm,
                        isSecure: true
                    )
                    
                    BulkUpButton(
                        text: "Log In",
                        color: .blue,
                        isDisabled: true,
                        isFullWidth: true,
                        onClick: logIn
                    )
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal, 80)
            }
        }
    }
}

#Preview {
    LogInView()
}
