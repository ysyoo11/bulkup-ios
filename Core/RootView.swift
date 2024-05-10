//
//  RootView.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 9/5/2024.
//

import SwiftUI

struct RootView: View {
    
    @State private var showWelcomeView: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                ProfileView(showWelcomeView: $showWelcomeView)
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showWelcomeView = authUser == nil
        }
        .fullScreenCover(isPresented: $showWelcomeView) {
            NavigationStack {
                WelcomeView(showWelcomeView: $showWelcomeView)
                    .environmentObject(AuthenticationViewModel())
            }
        }
    }
}

#Preview {
    RootView()
}
