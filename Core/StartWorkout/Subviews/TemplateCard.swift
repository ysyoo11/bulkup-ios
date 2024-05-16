//
//  TemplateCard.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 12/5/2024.
//

import SwiftUI

struct TemplateCard: View {
    
    @ObservedObject private var viewModel = StartWorkoutViewModel()
    @Binding var selectedTemplateId: String
    @Binding var showingTemplatePreview: Bool
    
    var template: UserTemplateWithExercises

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(template.name)
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.bottom, 1)
                
                ForEach(template.exercises, id: \.exercise.id.self) { item in
                    Text("\(item.exercise.name) (\(item.exercise.category))")
                        .font(.subheadline)
                        .foregroundColor(.primaryGray)
                }
                Spacer()
            }
            .padding(15)
            .overlay(
                RoundedRectangle(cornerRadius:10)
                    .stroke(.secondaryGray, lineWidth: 1))
            .frame(minWidth: 170, minHeight: 140, maxHeight: 140, alignment: .top)
            .clipped()
            .onTapGesture {
                selectedTemplateId = template.id
                showingTemplatePreview = true
            }
            
            VStack {
                HStack {
                    Spacer()
                    BulkUpMenu(options: [
                        .option(text: "Delete", icon: "xmark", action: {
                            viewModel.removeUserTemplate(templateId: template.id)
                        }),
                        .option(text: "Rename", icon: "pencil", action: {
                            print("Rename tapped") // TODO:
                        }),
                        .option(text: "Edit Template", icon: "pencil", action: {
                            print("Edit Template tapped") // TODO:
                        })
                    ])
                }
                Spacer()
            }
            .padding(13)
        }
    }
}
