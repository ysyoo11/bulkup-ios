//
//  TextFieldWithDebounce.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 11/5/2024.
//

import SwiftUI

struct TextFieldWithDebounce: View {
    @Binding var debouncedText : String
    @StateObject private var textObserver = TextFieldObserver()
    
    var body: some View {
    
        VStack {
            BulkUpTextField(placeholder: "Search", type: .light, isSearch: true, text: $textObserver.searchText)
        }.onReceive(textObserver.$debouncedText) { (val) in
            debouncedText = val
        }
    }
}
