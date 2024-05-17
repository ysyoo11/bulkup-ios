//
//  ProfileView.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 10/5/2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showWelcomeView: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    if let user = viewModel.user {
                        HStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.primaryGray)
                                .padding()
                                .background(.secondaryGray)
                                .clipShape(Circle())
                            Text(user.username ?? user.email!)
                                .font(.title3)
                                .bold()
                                .padding(.leading, 10)
                        }
                        Spacer()
                    }
                }
                Spacer()
            }
            .padding()
            .padding(.top, 20)
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
