//
//  ProfileView.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 9/5/2024.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
    }
}

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @Binding var showWelcomeView: Bool
    
    private func signOut() {
        print("Sign out tapped!")
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
            Text("Profile")
                .font(.title)
                .bold()
            
            BulkUpButton(
                text: "Log out",
                color: .pink,
                isDisabled: false,
                isFullWidth: true,
                onClick: signOut
            )
            
            Spacer()
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        .padding()
        .padding(.top, 20)
    }
}

#Preview {
    ProfileView(showWelcomeView: .constant(false))
}
