//
//  TemplateEditMenu.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 6/5/2024.
//

import SwiftUI

let templateEditMenuOptions: [MenuContent] = [
    .option(text: "Delete", icon: "xmark", action: {
        print("Delete tapped")
    }),
    .option(text: "Rename", icon: "pencil", action: {
        print("Rename tapped")
    }),
    .option(text: "Edit Template", icon: "pencil", action: {
        print("Edit Template tapped")
    })
]

struct TemplateEditMenu: View {
    var body: some View {
        BulkUpMenu(options: templateEditMenuOptions)
    }
}

#Preview {
    TemplateEditMenu()
}
