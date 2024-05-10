//
//  SettingsView.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 9/5/2024.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
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
        VStack {
            Text("Settings")
                .font(.title)
                .bold()
            
            BulkUpButton(
                text: "Log out",
                color: .pink,
                isDisabled: false,
                isFullWidth: true,
                onClick: signOut
            )
            
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
            
            Spacer()
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        .padding()
        .padding(.top, 20)
    }
}

#Preview {
    SettingsView(showWelcomeView: .constant(false))
}
