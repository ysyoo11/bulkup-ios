//
//  NewExercise.swift
//  BulkUp
//
//  Created by Yuta Horiuchi on 9/5/2024.
//

import SwiftUI

struct NewExerciseDialog: View {
    
    let allBodyParts = BodyPart.allCases.map { $0.rawValue }
    let allCategories = ExerciseCategory.allCases.map { $0.rawValue }
    @State var selectedBodyPart = ""
    @State var selectedCategory = ""
    @Binding var isActive: Bool
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.5)
                .onTapGesture {
                    isActive = false
                }
            NavigationView {
                List {
//                    BulkUpTextField(placeholder: "Add Name", type: .light, isSearch: false, size: .sm)
//                        .padding(.vertical)
                    
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
                        SetListButton(text: "X", foregroundColor: .primaryGray, backgroundColor: .secondaryGray, action: { isActive = false })
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            //Add new exercise
                            isActive = false
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


