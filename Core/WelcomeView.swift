//
//  WelcomeView.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 8/5/2024.
//

import SwiftUI

@MainActor
final class WelcomeViewModel: ObservableObject {
    
    @Published var errorMessage: String = ""
    
    func signInWithGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResultModel = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
              
        // TODO: Enable it after refactoring authentication logic
//            try await UserManager.shared.createNewUser(auth: authDataResultModel)
    }
}

struct WelcomeView: View {
    @StateObject private var viewModel = WelcomeViewModel()
    @Binding var showWelcomeView: Bool
    
    private func signInWithGoogle() {
        Task {
            do {
                try await viewModel.signInWithGoogle()
                showWelcomeView = false
            } catch {
                print(error) // TODO: Error handling
            }
        }
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
                            imageResource: .googleLogo,
                            onClick: signInWithGoogle
                        )
                        .padding(.horizontal, 80)
                        
                        BulkUpNavigationLink(
                            text: "Sign Up",
                            destination: SignUpView(showWelcomeView: $showWelcomeView),
                            type: .blue,
                            isFullWidth: true,
                            isDisabled: false
                        )
                        .padding(.horizontal, 80)
                        
                        BulkUpNavigationLink(
                            text: "Log In",
                            destination: LogInView(showWelcomeView: $showWelcomeView),
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
    WelcomeView(showWelcomeView: .constant(true))
}
