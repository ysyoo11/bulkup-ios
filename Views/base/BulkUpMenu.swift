//
//  BulkUpMenu.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 6/5/2024.
//

import SwiftUI

enum MenuContent {
    case option(text: String, icon: String, action: () -> Void)
    case navigationOption(text: String, icon: String, destination: AnyView)
}

struct MenuButton: View {
    var content: MenuContent
    
    var body: some View {
        switch content {
        case .option(let text, let icon, let action):
            Button(action: action) {
                Label(text, systemImage: icon)
            }
        case .navigationOption(let text, let icon, let destination):
            NavigationLink(destination: destination) {
                Label(text, systemImage: icon)
            }
        }
    }
}

struct BulkUpMenu: View {
    var options: [MenuContent]
    
    var body: some View {
        NavigationStack {
            Menu {
                ForEach(Array(options.enumerated()), id: \.offset) { _, option in
                    MenuButton(content: option)
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.primaryBlue)
                    .font(.body)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 10)
                    .background(.secondaryBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

let testOptions: [MenuContent] = ongoingExerciseMenuOptions

#Preview {
    BulkUpMenu(options: testOptions)
}
