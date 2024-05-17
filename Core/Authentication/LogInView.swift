//
//  LogInView.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 8/5/2024.
//

import SwiftUI
import Combine

@MainActor
final class LogInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}

struct LogInView: View {
    @StateObject var viewModel = LogInViewModel()
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
                    Text("Log In")
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
                    .onChange(of: viewModel.email, {
                        errorMessage = ""
                    })
                    
                    BulkUpTextField(
                        placeholder: "",
                        type: .dark,
                        label: "Password",
                        size: .sm,
                        isSecure: true,
                        text: $viewModel.password
                    )
                    .onChange(of: viewModel.password, {
                        errorMessage = ""
                    })
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundStyle(.primaryRed)
                    }
                                        
                    BulkUpButton(
                        text: "Log In",
                        color: .blue, 
                        isDisabled: viewModel.email.isEmpty || viewModel.password.count < 6,
                        isFullWidth: true,
                        onClick: {
                            Task {
                                do {
                                    try await viewModel.signIn()
                                    showWelcomeView = false
                                } catch {
                                    print(error)
                                    errorMessage = "\(error.localizedDescription) Please try again."
                                }
                            }
                        })
                    .padding(.top, 15)
                    
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal, 80)
            }
        }
    }
}

#Preview {
    LogInView(showWelcomeView: .constant(true))
}
