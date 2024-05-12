//
//  TemplateEditMenu.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 6/5/2024.
//

import SwiftUI

struct TemplateEditMenu: View {
    @StateObject private var viewModel = StartWorkoutViewModel()
    let templateId: String
    
    var body: some View {
        BulkUpMenu(options: [
            .option(text: "Delete", icon: "xmark", action: {
                viewModel.removeUserTemplate(templateId: templateId)
            }),
            .option(text: "Rename", icon: "pencil", action: {
                print("Rename tapped")
            }),
            .option(text: "Edit Template", icon: "pencil", action: {
                print("Edit Template tapped")
            })
        ])
    }
}

//#Preview {
//    TemplateEditMenu(templateId: <#T##String#>)
//}
