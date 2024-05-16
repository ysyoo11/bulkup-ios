//
//  TextFieldWithDebounce.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 11/5/2024.
//

import SwiftUI
import Combine

class TextFieldObserver : ObservableObject {
    @Published var debouncedText = ""
    @Published var searchText = ""
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] t in
                self?.debouncedText = t
            } )
            .store(in: &subscriptions)
    }
}

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
