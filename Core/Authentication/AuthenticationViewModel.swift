//
//  AuthenticationViewModel.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 10/5/2024.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func signInWithGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        let user = DBUser(auth: authDataResult)
        
        try await UserManager.shared.createNewUser(user: user)
    }
    
}
