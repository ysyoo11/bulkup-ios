//
//  WelcomeView.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 8/5/2024.
//

import SwiftUI

struct WelcomeView: View {
    @State private var isShowingSignUp = false
    
    // TODO: Google sign-up
    private func signInWithGoogle() {
        print("Sign in with Google")
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Image(.welcome)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                Rectangle()
                    .opacity(0.6)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    VStack {
                        Text("Welcome to BulkUp")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Your workout journey starts here.")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 15) {
                        BulkUpButton(
                            text: "Sign in with Google",
                            color: .gray,
                            isDisabled: false,
                            isFullWidth: true,
                            onClick: signInWithGoogle
                        )
                        .padding(.horizontal, 80)
                        
                        BulkUpNavigationLink(
                            text: "Sign Up",
                            destination: SignUpView(),
                            type: .blue,
                            isFullWidth: true,
                            isDisabled: false
                        )
                        .padding(.horizontal, 80)
                        
                        BulkUpNavigationLink(
                            text: "Log In",
                            destination: LogInView(),
                            type: .noBorder,
                            isDisabled: false
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
