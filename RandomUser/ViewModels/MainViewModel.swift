//
//  MainViewModel.swift
//  RandomUser
//
//  Created by Arnau on 10/06/2026.
//

import Combine
import Foundation

final class MainViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil
    
    // MARK: - Dependencies
    
    private let service: RandomUsersServicesProtocol
    
    init(service: RandomUsersServicesProtocol = RandomUsersServices()) {
        self.service = service
    }
    
    func fetchUsers() async {
        isLoading = true
        error = nil
        
        do {
            users = try await service.fetchRandomUsers(resultsNumber: 20).results
            print(users)
        } catch {
            self.error = error
            print(self.error?.localizedDescription ?? "")
        }
        
        isLoading = false
    }
}
