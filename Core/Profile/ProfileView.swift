//
//  ProfileView.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 10/5/2024.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
}

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showWelcomeView: Bool
    
    var body: some View {
        NavigationStack {
            List {
                if let user = viewModel.user {
                    Text("UserId: \(user.userId)")
                }
            }
            .task {
                try? await viewModel.loadCurrentUser()
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView(showWelcomeView: $showWelcomeView)
                    } label: {
                        Image(systemName: "gear")
                            .font(.headline)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(showWelcomeView: .constant(false))
    }
}
