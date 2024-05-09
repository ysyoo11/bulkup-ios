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
        
        let returnedUserData = try await AuthenticationManager.shared.signIn(email: email, password: password)
        print(returnedUserData)
    }
}

struct LogInView: View {
    @StateObject var viewModel = LogInViewModel()
    @Binding var showWelcomeView: Bool
    
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
                    
                    BulkUpTextField(
                        placeholder: "",
                        type: .dark,
                        label: "Password",
                        size: .sm,
                        isSecure: true,
                        text: $viewModel.password
                    )
                    
                    // TODO: Modify BulkUpButton and use the component
                    Button {
                        Task {
                            do {
                                try await viewModel.signIn()
                                showWelcomeView = false
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("Log In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .background(.primaryBlue)
                            .cornerRadius(6)
                    }
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
    LogInView(showWelcomeView: .constant(true))
}
