//
//  NewTemplateView.swift
//  BulkUp
//
//  Created by Eunbyul Cho on 9/5/2024.
//

import SwiftUI

struct NewTemplateView: View {
    @Binding var isPresented: Bool
    @State private var templateName: String = ""
    @State private var templateNotes: String = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .imageScale(.large)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Text("New Template")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {
                        saveTemplate()  // Save it to db
                    }) {
                        Text("Save")
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    TextField("Template name", text: $templateName)
                        .padding()
                        .font(.title)
                        .bold()
                    TextField("Enter notes", text: $templateNotes)
                        .padding()
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .navigationBarHidden(true)
        }
    }

    private func saveTemplate() {
        print("Saving Template: \(templateName) with notes: \(templateNotes)")
        isPresented = false
    }
}

struct NewTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        NewTemplateView(isPresented: .constant(true))
    }
}
