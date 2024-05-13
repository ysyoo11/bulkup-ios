//
//  TemplateCard.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 12/5/2024.
//

import SwiftUI

struct TemplateCard: View {
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
                ForEach(template.exercises, id: \.exercise.id.self) { item in
                    Text("\(item.exercise.name) (\(item.exercise.category))")
                        .font(.subheadline)
                        .foregroundColor(.primaryGray)
                }
                Spacer()
            }
            .padding()
            .background(.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius:10)
                    .stroke(.secondaryGray, lineWidth: 1)
                    .frame(minWidth: 170, minHeight: 140, maxHeight: 140))
            .frame(minWidth: 170, maxHeight: 160)
            .onTapGesture {
                selectedTemplateId = template.id
                showingTemplatePreview = true
            }
            VStack {
                HStack {
                    Spacer()
                    TemplateEditMenu(templateId: template.id)
                }
                Spacer()
            }
            .padding()
        }
    }
}
