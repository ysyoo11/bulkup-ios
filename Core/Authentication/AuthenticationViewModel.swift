//
//  MyAuthenticationViewModel.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 10/5/2024.
//

import Foundation

@MainActor
final class WelcomeViewModel: ObservableObject {
    
    func signInWithGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResultModel = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
              
        // TODO: Enable it after refactoring authentication logic
//            try await UserManager.shared.createNewUser(auth: authDataResultModel)
    }
    
}
