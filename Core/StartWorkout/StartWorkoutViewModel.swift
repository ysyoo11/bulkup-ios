//
//  StartWorkoutViewModel.swift
//  BulkUp
//
//  Created by Yeonsuk Yoo on 12/5/2024.
//

import Foundation
import Combine

@MainActor
final class StartWorkoutViewModel: ObservableObject {
    
    @Published private(set) var templates: [UserTemplate] = []
    private var cancellables = Set<AnyCancellable>()
    
    func addListenerForTemplates() {
        guard let authDataResult = try? AuthenticationManager.shared.getAuthenticatedUser() else { return }
        
//        UserManager.shared.addListenerForAllUserTemplates(userId: authDataResult.uid) { [weak self] templates in
//            self?.templates = templates
//        }
        UserManager.shared.addListenerForAllUserTemplates(userId: authDataResult.uid)
            .sink { completion in
                
            } receiveValue: { [weak self] templates in
                self?.templates = templates
            }
            .store(in: &cancellables)

    }
    
    func addUserTemplate(template: UserTemplate) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.addUserTemplate(userId: authDataResult.uid, template: template)
        }
    }
    
    func removeUserTemplate(templateId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.removeUserTemplate(userId: authDataResult.uid, templateId: templateId)
        }
    }
    
}
