//
//  SignInGoogleHelper.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 10/5/2024.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
    let name: String?
    let email: String?
}

final class SignInGoogleHelper {
    
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller!")
            throw URLError(.cannotFindHost)
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        let user = gidSignInResult.user
        
        guard let idToken = user.idToken else {
            throw AuthenticationError.tokenError(message: "ID token missing")
        }
        
        let accessToken = user.accessToken
        let name = user.profile?.name
        let email = user.profile?.email
        
        let tokens = GoogleSignInResultModel(idToken: idToken.tokenString, accessToken: accessToken.tokenString, name: name, email: email)
        
        return tokens
    }
}
