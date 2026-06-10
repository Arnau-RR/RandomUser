//
//  ProfileViewModel.swift
//  RandomUser
//
//  Created by Arnau on 10/06/2026.
//

import Combine
import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var userInformation: UserEntity
    
    init(userInformation: UserEntity) {
        self.userInformation = userInformation
    }
    
    func getInitials() -> String {
        let first = userInformation.firstName.first.map(String.init) ?? ""
        let last = userInformation.lastName.first.map(String.init) ?? ""
        return first + last
    }
    
    
}
