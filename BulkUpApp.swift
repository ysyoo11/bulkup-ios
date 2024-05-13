//
//  BulkUpApp.swift
//  BulkUp
//
//  Created by Yuta Horiuchi on 4/5/2024.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
//    Auth.auth().useEmulator(withHost: "localhost", port: 9099)
    return true
  }
}

@main
struct BulkUpApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var restTimerModel: CountDownTimerModel = .init()
    @Environment(\.scenePhase) var phase
    @State var lastActiveTimeStamp: Date = Date()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(restTimerModel)
        }
        .onChange(of: phase) { oldValue, newValue in
            if restTimerModel.isStarted {
                if newValue == .background {
                    lastActiveTimeStamp = Date()
                }
                
                if newValue == .active {
                    let currentTimeStampDiff = Date().timeIntervalSince(lastActiveTimeStamp)
                    if restTimerModel.totalSeconds - Int(currentTimeStampDiff) <= 0 {
                        restTimerModel.isStarted = false
                        restTimerModel.totalSeconds = 0
                        restTimerModel.isFinished = true
                    } else {
                        restTimerModel.totalSeconds -= Int(currentTimeStampDiff)
                    }
                }
            }
        }
    }
}
