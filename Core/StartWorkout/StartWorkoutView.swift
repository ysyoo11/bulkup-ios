//
//  StartWorkoutView.swift
//  BulkUp
//
//  Created by Eunbyul Cho on 9/5/2024.
//

import SwiftUI

struct StartWorkoutView: View {
    
    @StateObject var viewModel = StartWorkoutViewModel()
    @State private var showingNewTemplate: Bool = false
    @State private var showingTemplatePreview: Bool = false
    @State private var selectedTemplateId: String = ""
    
    private let adaptiveColumns = [ GridItem(.adaptive(minimum: 170)) ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Section(header: Text("Quick Start").font(.headline).bold().padding(.top, 40)) {
                        BulkUpButton(
                            text: "Start an Empty Workout",
                            color: .blue,
                            isDisabled: false,
                            isFullWidth: true,
                            onClick: {
                                // TODO:
                                print("Start an empty workout tapped")
                            })
                    }

                    HStack {
                        Text("Templates")
                            .font(.title2)
                            .bold()
                        Spacer()
                        BulkUpButton(
                            text: "Template",
                            color: .skyblue,
                            isDisabled: false,
                            image: Image(systemName: "plus")
                        ) {
                            showingNewTemplate = true
                        }
                    }
                    
                    HStack {
                        Text("My Templates (\(viewModel.templates.count))")
                            .font(.headline)
                            .bold()
                    }
                    LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                        ForEach(viewModel.templates, id: \.id.self) { template in
                            TemplateCardViewBuilder(
                                templateId: template.id,
                                selectedTemplateId: $selectedTemplateId,
                                showingTemplatePreview: $showingTemplatePreview)
                        }
                        NewTemplateCard(onClick: {
                            showingNewTemplate = true
                        })
                    }

                    Spacer()
                }
                .navigationTitle("Start Workout")
                .sheet(isPresented: $showingNewTemplate) {
                    NewTemplateView(isPresented: $showingNewTemplate)
                }
                .sheet(isPresented: $showingTemplatePreview) {
                    TemplatePreviewBuilder(
                        selectedTemplateId: $selectedTemplateId,
                        showingTemplatePreview: $showingTemplatePreview)
                }
                .padding(.horizontal, 20)
                .onFirstAppear {
                    viewModel.addListenerForTemplates()
                }
            }
        }
    }
}
    
#Preview {
    StartWorkoutView()
}

