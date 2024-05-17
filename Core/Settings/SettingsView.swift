//
//  SettingsView.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 9/5/2024.
//

import SwiftUI

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
    
    private func deleteAccount() {
        Task {
            do {
                try await viewModel.deleteAccount()
                showWelcomeView = true
            } catch {
                print(error)
            }
        }
    }
    
    var body: some View {
        VStack {
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
                onClick: deleteAccount
            )
            .padding(.top, 10)
            
            if viewModel.authProviders.contains(.email) {
                Button {
                    Task {
                        do {
                            try await viewModel.resetPassword()
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
            Spacer()
        }
        .padding()
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
