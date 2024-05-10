//
//  RootView.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 9/5/2024.
//

import SwiftUI

struct RootView: View {
    
    @State private var showWelcomeView: Bool = false
    
    init() {
        UITabBar.appearance().backgroundColor = .primaryGray
        UITabBar.appearance().unselectedItemTintColor = .secondaryGray
    }
    
    var body: some View {
        ZStack {
            if !showWelcomeView {
                NavigationView {
                    TabView {
                        ProfileView(showWelcomeView: $showWelcomeView)
                            .tabItem {
                                Label("Profile", systemImage: "person")
                            }

                        HistoryView()
                            .tabItem {
                                Label("History", systemImage: "clock")
                            }

                        StartWorkoutView()
                            .tabItem {
                                Label("Start Workout", systemImage: "plus")
                            }

                        ExercisesView()
                            .tabItem {
                                Label("Exercises", systemImage: "flame")
                            }
                    }
                }
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showWelcomeView = authUser == nil
        }
        .fullScreenCover(isPresented: $showWelcomeView) {
            NavigationStack {
                WelcomeView(showWelcomeView: $showWelcomeView)
            }
        }
    }
}

#Preview {
    RootView()
}
