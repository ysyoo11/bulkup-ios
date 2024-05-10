//
//  SettingsView.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 9/5/2024.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw AuthError.runtimeError("User email undefined")
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
}

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    @Binding var showWelcomeView: Bool
    
    private func signOut() {
        Task {
            do {
                try viewModel.logOut()
                showWelcomeView = true
            } catch {
                print(error)
            }
        }
    }
    
    var body: some View {
        List {
            BulkUpButton(
                text: "Log out",
                color: .pink,
                isDisabled: false,
                isFullWidth: true,
                onClick: signOut
            )
            
            BulkUpButton(
                text: "Delete Account",
                color: .red,
                isDisabled: false,
                isFullWidth: true,
                onClick: {
                    Task {
                        do {
                            try await viewModel.deleteAccount()
                            showWelcomeView = true
                        } catch {
                            print(error)
                        }
                    }
                }
            )
            
            if viewModel.authProviders.contains(.email) {
                Button {
                    Task {
                        do {
                            try await viewModel.resetPassword()
                            print("password reset!")
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Text("Reset Password")
                        .font(.headline)
                        .foregroundColor(.primaryBlue)
                        .cornerRadius(6)
                        .underline()
                }
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .onAppear {
            viewModel.loadAuthProviders()
        }
        .navigationBarTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showWelcomeView: .constant(false))
    }
}
