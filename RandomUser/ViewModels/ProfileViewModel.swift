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
        
        print(userInformation.latitude)
        print(userInformation.longitude)
    }
    
    func getInitials() -> String {
        let first = userInformation.firstName.first.map(String.init) ?? ""
        let last = userInformation.lastName.first.map(String.init) ?? ""
        return first + last
    }
    
    func getGenderWithTranslation() -> String {
        return userInformation.gender == "male"
            ? String(localized: "male")
            : String(localized: "female")
    }
    
    func getMemberSinceFormatted() -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = isoFormatter.date(from: userInformation.registeredDate) else {
            return ""
        }
        
        // 2. Mostrar al usuario con formato local
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .long
        displayFormatter.timeStyle = .short
        displayFormatter.locale = Locale.current
        
       return displayFormatter.string(from: date)
    }
    
//    func getFormattedAddress() -> String {
//        """
//        \(userInformation.streetName) \(userInformation.streetNumber)
//        • \(userInformation.city), \(userInformation.state)
//        """
//    }
    
    func getFullAddress() -> String {
        return "\(userInformation.streetName), \(userInformation.streetNumber), \(userInformation.city), \(userInformation.state)"
    }
    
    
}
