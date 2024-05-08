//
//  HistoryCard.swift
//  BulkUp
//
//  Created by Eunbyul Cho on 8/5/2024.
//

import SwiftUI

struct HistoryCard: View {
    var history: History

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    Text(history.template)
                        .bold()
                    Text(history.createdAt, style: .date)
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

var tempHistory: History = History(
    id: "1",
    template: "template",
    duration: 1000,
    createdAt: Date(),
    volume: 2000,
    userId: "userId"
)

#Preview {
    HistoryCard(history: tempHistory)
}