//
//  RestTimerView.swift
//  BulkUp
//
//  Created by Yuta Horiuchi on 10/5/2024.
//

import SwiftUI

struct RestTimerView: View {
    
    @EnvironmentObject var countDownTimerModel: CountDownTimerModel
    @Binding var isActive: Bool
    @State var isDialogActive: Bool = false
    var duration: Int
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    isActive = false
                }
            NavigationView {
                
                VStack {
                    Text("Adjust duration via the +/- buttons.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    GeometryReader{ proxy in
                        VStack (spacing: 15) {
                            ZStack {
                                ZStack {
                                    Circle()
                                        .stroke(Color.secondaryGray, lineWidth: 8)
                                    Circle()
                                        .trim(from: 0, to: countDownTimerModel.progress)
                                        .stroke(Color.blue.opacity(0.7), lineWidth: 8)
                                }
                                .padding()
                                .frame(height: proxy.size.width)
                                .rotationEffect(.init(degrees: -90))
                                .animation(.easeInOut, value: countDownTimerModel.progress)
                                VStack {
                                    Text(countDownTimerModel.timerStringValue)
                                        .font(.system(size: 55, weight: .bold))
                                        .animation(.none, value: countDownTimerModel.progress)
                                    Text(countDownTimerModel.staticTimerStringValue)
                                        .font(.system(size: 30, weight: .bold))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                            if countDownTimerModel.isStarted {
                                countDownTimerModel.updateTimer()
                            }
                        }
                        .alert(isPresented: $countDownTimerModel.isFinished) {
                            Alert(
                                title: Text("🏋️\n\nRest Complete!"),
                                message: Text("Get back to work!"),
                                dismissButton: .default(Text("OK"), action: { isActive = false} )
                            )
                        }
                    }
                        
                    HStack {
                        BulkUpButton(text: "-10s", color: .gray, isDisabled: false, isFullWidth: true, onClick: {
                            countDownTimerModel.editTimer(sec: -10)
                        })
                        BulkUpButton(text: "+10s", color: .gray, isDisabled: false, isFullWidth: true, onClick: {
                            countDownTimerModel.editTimer(sec: 10)
                        })
                        BulkUpButton(text: "Skip", color: .blue, isDisabled: false, isFullWidth: true, onClick: {
                            countDownTimerModel.stopTimer()
                            isActive = false
                        })
                    }
                }
                .padding()
                .navigationTitle("Rest Timer")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        SetListButton(text: "X", foregroundColor: .primaryGray, backgroundColor: .secondaryGray, action: { isActive = false })
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        SetListButton(text: "?", foregroundColor: .primaryGray, backgroundColor: .secondaryGray, action: { isDialogActive = true } )
                    }
                }
            }
            .frame(height: 500)
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding()
            .onAppear() {
                if !countDownTimerModel.isStarted {
                    countDownTimerModel.totalSeconds = duration
                    countDownTimerModel.isStarted = true
                    countDownTimerModel.startTimer()
                }
            }
            if isDialogActive {
                restTimerGuideDialog(isActive: $isDialogActive)
            }
        }
        .ignoresSafeArea()
    }
}



struct restTimerGuideDialog: View {
    
    @Binding var isActive: Bool
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    isActive = false
                }
            NavigationView{
                VStack {
                    Text("About Rest Timer")
                        .padding()
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("Manually set a Rest Timer at any time.\n\nAuto Timers can be set up to start when a set is completed.\n\nSet an Auto Timer via the More (...) Menu for any exercise. Each exercise can have its own custom duration, independent of others.")
                        .padding()
                        .foregroundColor(.primaryGray)
                        .font(Font.system(size: 16))
                        .multilineTextAlignment(.center)
                    BulkUpButton(text: "Cool!", color: .gray, isDisabled: false, isFullWidth: true, onClick: { isActive = false })
                        .padding()
                }
            }
            .frame(height: 350)
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding()
        }
        .ignoresSafeArea()
    }
}



#Preview {
    RestTimerView(isActive: .constant(true), duration: 120)
        .environmentObject(CountDownTimerModel())
}
