//
//  HistoryCard.swift
//  BulkUp
//
//  Created by Eunbyul Cho on 8/5/2024.
//

import SwiftUI

struct HistoryCard: View {
    var history: UserHistoryWithInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    Text(history.template.name)
                        .bold()
                    Text(history.createdAt ?? Date(), style: .date)
                        .font(.subheadline)
                }
                Spacer()
                HistoryEditMenu()
                    .contentShape(Rectangle())
                    .frame(width: 55, height: 44)
            }

            HStack {
                Image(systemName: "clock")
                Text("\(history.duration) min")
        
                Image(systemName: "scalemass")
                Text("\(history.volume) kg")
            }
            .font(.caption)

            Divider()
        }
        .padding([.leading, .top, .bottom])
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 1)
        .padding(.horizontal, 10)
    }
}

var tempHistory: UserHistoryWithInfo = UserHistoryWithInfo(
    id: "1",
    template: UserTemplateWithExercises(id: "1", name: "Template A", exercises: [], createdAt: Date(), updatedAt: Date()),
    duration: 100,
    volume: 1000,
    createdAt: Date() - 1000,
    updatedAt: Date() - 1000
)

#Preview {
    HistoryCard(history: tempHistory)
}
