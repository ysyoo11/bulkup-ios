//
//  TemplatePreview.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 13/5/2024.
//

import SwiftUI
import ModalView

struct TemplatePreview: View {
    @Binding var showingTemplatePreview: Bool
    @Binding var previewTemplateId: String
//    let templateId: String
    
    var body: some View {
        Text("Template Preview: \(previewTemplateId)")
    }
}

//#Preview {
//    TemplatePreview(showingTemplatePreview: .constant(true), templateId: "TCk6IkX1Ceik740ZmFHI")
//    TemplatePreview(showingTemplatePreview: .constant(true), previewTemplateId: "TCk6IkX1Ceik740ZmFHI")
//}
