//
//  SignInEmailViewModel.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 10/5/2024.
//

import Foundation

@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    private func verifyEmailPassword() {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
    }
    
    func signUp() async throws {
        verifyEmailPassword()
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
    
    func signIn() async throws {
        verifyEmailPassword()
        
        let authDataResult = try await AuthenticationManager.shared.signIn(email: email, password: password)
    }
}
