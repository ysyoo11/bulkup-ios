//
//  NewExercise.swift
//  BulkUp
//
//  Created by Yuta Horiuchi on 9/5/2024.
//

import SwiftUI

struct NewExerciseDialog: View {
    
    @State var text: String = ""
    @State var selectedBodyPart = ""
    @State var selectedCategory = ""
    @Binding var isActive: Bool
    
    let allBodyParts = BodyPart.allCases.map { $0.rawValue }
    let allCategories = ExerciseCategory.allCases.map { $0.rawValue }
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    isActive = false
                }
            NavigationView {
                List {
                    BulkUpTextField(placeholder: "Add Name", type: .light, isSearch: false, size: .sm, text: $text)
                    
                    Picker("Body Part", selection: $selectedBodyPart) {
                        if selectedBodyPart.isEmpty {
                            Text("Select").tag(Optional(-1))
                        }
                        ForEach(allBodyParts, id: \.self) { bodyPart in
                            Text(bodyPart)
                        }
                    }.pickerStyle(.navigationLink)
                    
                    Picker("Category", selection: $selectedCategory) {
                        if selectedCategory.isEmpty {
                            Text("Select").tag(Optional(-1))
                        }
                        ForEach(allCategories, id: \.self) { category in
                            Text(category)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                .listStyle(GroupedListStyle())
                .navigationTitle("Create New Exercise")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            isActive = false
                        } label: {
                            Image(systemName: "xmark")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 6)
                                .background(.secondaryGray)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .tint(.primaryGray)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            // TODO: Add new exercise
                            isActive = false
                        } label: {
                            Text("Save")
                                .underline()
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            .frame(height: 280)
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    NewExerciseDialog(isActive: .constant(true))
}


