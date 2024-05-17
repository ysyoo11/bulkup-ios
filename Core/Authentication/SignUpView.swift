//
//  SignUpView.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 8/5/2024.
//

import SwiftUI
import Combine

@MainActor
final class SignUpEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
}

struct SignUpView: View {
    @StateObject private var viewModel = SignUpEmailViewModel()
    @Binding var showWelcomeView: Bool
    
    @State private var errorMessage: String = ""
    
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
                    Text("Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                    BulkUpTextField(
                        placeholder: "",
                        type: .dark,
                        label: "Email Address",
                        size: .sm,
                        text: $viewModel.email
                    )
                    .padding(.top, 20)
                    .onChange(of: viewModel.email, {
                        errorMessage = ""
                    })
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundStyle(.primaryRed)
                    }
                    
                    BulkUpTextField(
                        placeholder: "",
                        type: .dark,
                        label: "Password",
                        size: .sm,
                        isSecure: true,
                        text: $viewModel.password
                    )
                    
                    BulkUpButton(
                        text: "Sign Up",
                        color: .blue,
                        isDisabled: viewModel.email.isEmpty || viewModel.password.count < 6,
                        isFullWidth: true,
                        onClick: {
                            Task {
                                do {
                                    try await viewModel.signUp()
                                    showWelcomeView = false
                                } catch {
                                    print(error)
                                    errorMessage = error.localizedDescription
                                }
                            }
                        })
                    
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal, 80)
            }
        }
    }
}

#Preview {
    SignUpView(showWelcomeView: .constant(true))
}
