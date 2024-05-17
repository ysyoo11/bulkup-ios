//
//  HistoryView.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 8/5/2024.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @State private var showingHistoryDetail: Bool = false
    @State private var selectedHistoryId: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.histories.isEmpty {
                    Text("No workout histories yet.")
                        .font(.subheadline)
                } else {
                    ScrollView {
                        ForEach(viewModel.histories, id: \.id.self) { history in
                            HistoryCardBuilder(
                                historyId: history.id,
                                selectedHistoryId: $selectedHistoryId,
                                showingHistoryDetail: $showingHistoryDetail)
                        }
                    }
                    .padding(.top, 20)
                    Spacer()
                }
            }
            .navigationTitle("History")
            .onFirstAppear {
                viewModel.addListenerForHistories()
            }
        }
    }
}

#Preview {
    HistoryView()
}
