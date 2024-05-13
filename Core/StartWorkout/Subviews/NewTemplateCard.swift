//
//  NewTemplateCard.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 12/5/2024.
//

import SwiftUI

struct NewTemplateCard: View {
    var onClick: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            BulkUpButton(text: "Tap to Add New Template", color: .clear, isDisabled: false, onClick: onClick)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius:10)
                .stroke(.secondaryGray, lineWidth: 1)
                .frame(minWidth: 170, minHeight: 140, maxHeight: 140))
        .frame(minWidth: 170, minHeight: 140, maxHeight: 140)
    }
}

#Preview {
    NewTemplateCard(onClick: {})
}
