//
//  TimerModel.swift
//  BulkUp
//
//  Created by Yuta Horiuchi on 10/5/2024.
//

import Foundation
import SwiftUI

class TimerSettings: ObservableObject {
    
    @Published var isEnabled: Bool = false
    @Published var timer: Int = 120
    
}

class CountDownTimerModel: NSObject, ObservableObject {
    
    var minutes: Int = 0
    var seconds: Int = 0
    @Published var progress: CGFloat = 1
    @Published var isStarted: Bool = false
    @Published var isFinished: Bool = false
    @Published var totalSeconds: Int = 0
    var staticTotalSeconds: Int = 0
    @Published var timerStringValue: String = "00:00"
    @Published var staticTimerStringValue: String = "00:00"
    
    func startTimer() {
        withAnimation(.easeInOut(duration: 0.25)) { isStarted = true }
        staticTotalSeconds = totalSeconds
        minutes = (totalSeconds / 60) % 60
        seconds = totalSeconds % 60
        timerStringValue = "\(minutes):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        staticTimerStringValue = timerStringValue
    }
    
    func stopTimer() {
        isStarted = false
        totalSeconds = 0
        minutes = 0
        seconds = 0
        staticTotalSeconds = 0
        timerStringValue = "00:00"
        staticTimerStringValue = "00:00"
        progress = 1
    }
    
    func updateTimer() {
        totalSeconds -= 1
        progress = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        progress = (progress < 0 ? 0 : progress)
        minutes = (totalSeconds / 60) % 60
        seconds = totalSeconds % 60
//        print("TotalSeconds: \(totalSeconds)")
//        print("Minutes: \(minutes)")
//        print("Seconds: \(seconds)")
        timerStringValue = "\(minutes):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        if minutes <= 0 && seconds <= 0 {
            stopTimer()
            isFinished = true
        }
    }
    
    func editTimer(sec: Int) {
        staticTotalSeconds += sec
        totalSeconds += sec + 1
        staticTimerStringValue = "\((staticTotalSeconds / 60) % 60):\((staticTotalSeconds % 60) >= 10 ? "\(staticTotalSeconds % 60)" : "0\(staticTotalSeconds % 60)")"
        updateTimer()
    }
}


class CountUpTimerModel: NSObject, ObservableObject {
    
    var minutes: Int = 0
    var seconds: Int = 0
    @Published var isStarted: Bool = false
    @Published var isFinished: Bool = false
    @Published var totalSeconds: Int = 0
    @Published var timerStringValue: String = "00:00"
    
    func stopTimer() {
        isStarted = false
        totalSeconds = 0
        minutes = 0
        seconds = 0
        timerStringValue = "00:00"
    }
    
    func updateTimer() {
        totalSeconds += 1
        minutes = (totalSeconds / 60) % 60
        seconds = totalSeconds % 60
//        print("TotalSeconds: \(totalSeconds)")
//        print("Minutes: \(minutes)")
//        print("Seconds: \(seconds)")
        timerStringValue = "\(minutes):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
    }
}
