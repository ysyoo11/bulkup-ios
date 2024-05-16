//
//  HistoryViewModel.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 16/5/2024.
//

import Foundation
import Combine

@MainActor
final class HistoryViewModel: ObservableObject {
    
    @Published private(set) var histories: [UserHistory] = []
    private var cancellables = Set<AnyCancellable>()
    
    func addListenerForHistories() {
        guard let authDataResult = try?
                AuthenticationManager.shared.getAuthenticatedUser() else { return }
        UserManager.shared.addListenerForAllUserHistories(userId: authDataResult.uid)
            .sink { completion in
                
            } receiveValue: { [weak self] histories in
                self?.histories = histories
            }
            .store(in: &cancellables)
    }
    
    func getAllHistories() {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            self.histories = try await UserManager.shared.getAllUserHistories(userId: authDataResult.uid)
        }
    }
    
    func deleteHistory(historyId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try await UserManager.shared.removeUserHistory(userId: authDataResult.uid, historyId: historyId)
        }
    }
    
}
