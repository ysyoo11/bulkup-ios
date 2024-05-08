//
//  BulkUpDialog.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 6/5/2024.
//

import SwiftUI

enum DialogType: String {
    case alert = "alert"
    case confirm = "confirm"
}

struct BulkUpDialog: View {
    @Binding var isActive: Bool

    var type: DialogType? = .confirm
    let title: String
    let message: String
    let actionButtonTitle: String
    let action: () -> Void
    let cancelButtonTitle: String
    let onClose: () -> Void
    @State private var offset: CGFloat = 1000
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    close()
                }
            VStack {
                Text(title)
                    .font(.title3)
                    .bold()
                    .padding()

                Text(message)
                    .font(.body)
                    .foregroundStyle(.primaryGray)
                    .multilineTextAlignment(.center)
                
                VStack {
                    BulkUpButton(
                        text: actionButtonTitle,
                        color: type == .alert ? .red : .green,
                        isDisabled: false,
                        isFullWidth: true,
                        onClick: {
                            action()
                            close()
                        }
                    )
                    BulkUpButton(
                        text: cancelButtonTitle,
                        color: .gray,
                        isDisabled: false,
                        isFullWidth: true,
                        onClick: close
                    )
                }
                .padding(.top, 20)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(alignment: .topTrailing) {
                Button {
                    close()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .fontWeight(.medium)
                }
                .tint(.black)
                .padding()
            }
            .shadow(radius: 20)
            .padding(30)
            .offset(x: 0, y: offset)
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0
                }
            }
        }
        .ignoresSafeArea()
        
    }

    func close() {
        withAnimation(.spring()) {
            offset = 1000
            isActive = false
        }
        onClose()
    }
}

#Preview {
    BulkUpDialog(
        isActive: .constant(true),
        type: .alert,
        title: "Cancel Workout?",
        message: "Are you sure you want to cancel this workout? All progress will be lost.",
        actionButtonTitle: "Cancel Workout",
        action: { print("Cancel Workout tapped.") },
        cancelButtonTitle: "Resume",
        onClose: {
            print("Closed!")
        }
    )
}
