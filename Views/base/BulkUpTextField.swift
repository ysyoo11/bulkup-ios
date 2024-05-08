//
//  BulkUpTextField.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 6/5/2024.
//

import SwiftUI

enum TextFieldType {
    case light, dark, noBorder

    var backgroundColor: Color {
        switch self {
        case .light: return .secondaryGray
        case .dark: return .primaryGray
        case .noBorder: return .white
        }
    }
    
    var borderColor: Color {
        switch self {
        case .light: return .primaryGray
        case .dark: return .white
        case .noBorder: return .clear
        }
    }

    var textColor: Color {
        switch self {
        case .light: return .primaryGray
        case .dark: return .white
        case .noBorder: return .primaryGray
        }
    }
}

enum TextFieldSize {
    case xs, sm, base, lg
    
    var fontSize: CGFloat {
        switch self {
        case .xs: return 12
        case .sm: return 16
        case .base: return 20
        case .lg: return 28
        }
    }
}

struct BulkUpTextField: View {
    var placeholder: String = ""
    var type: TextFieldType = .light
    var isSearch: Bool = false
    var label: String?
    var size: TextFieldSize = .base
    
    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            if let label = label {
                Text(label).font(.system(size: 16)).foregroundColor(type.textColor)
            }
            HStack {
                if isSearch {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 10)
                        .foregroundColor(type.textColor)
                }
                TextField(placeholder, text: $text)
                    .foregroundColor(type.textColor)
                    .font(Font.system(size: size.fontSize))
                    .padding(isSearch
                             ? .init(top: 10, leading: 0, bottom: 10, trailing: 10)
                             : .init(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .focused($isFocused)
            }
            .background(type.backgroundColor)
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isFocused ? type.borderColor : .clear, lineWidth: 2)
            )
        }
    }
}

#Preview {
    VStack {
        Spacer()
        
        VStack {
            Spacer()
            Text("Light Background").font(.headline)
            Spacer()
            BulkUpTextField(placeholder: "100", type: .light)
            BulkUpTextField(placeholder: "Search", type: .light, isSearch: true)
            BulkUpTextField(placeholder: "Template name", type: .noBorder, size: .lg)
            Spacer()
        }
        
        Spacer()
        
        VStack {
            Spacer()
            Text("Dark Background").foregroundStyle(.white).font(.headline)
            Spacer()
            BulkUpTextField(placeholder: "yysuk0302@gmail.com", type: .dark, label: "Email")
            Spacer()
        }
        .background(.black)
        .padding(.vertical)
        
        Spacer()
    }
    .padding()
}
