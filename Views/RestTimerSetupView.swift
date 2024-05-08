//
//  RestTimerView.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 6/5/2024.
//

import SwiftUI

struct RestTimerSetupView: View {
//    var userId: String
//    var exerciseId: String
    let minRestTime = 30
    let maxRestTime = 300
    @State private var isEnabled = false
    @State var timer: Int = 120
    
    private func parseSecToStr(time: Int) -> String {
        let min = time / 60
        let secRemainder = time % 60
        let sec = secRemainder < 10 ? "0\(secRemainder)" : "\(secRemainder)"
        return "\(min):\(sec)"
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $isEnabled) {
                        Text("Enabled")
                    }
                }

                Section(header: Text("Time Presets")) {
                    Picker("", selection: $timer){
                        ForEach(minRestTime...maxRestTime, id: \.self) { i in
                            if i % 10 == 0 {
                                Text(parseSecToStr(time: i)).tag(i)
                            }
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .disabled(!isEnabled)
                }
                .opacity(isEnabled ? 1.0 : 0.4)
            }
            .navigationBarTitle("Auto Rest Timer")
        }
    }
}

#Preview {
    RestTimerSetupView()
}
