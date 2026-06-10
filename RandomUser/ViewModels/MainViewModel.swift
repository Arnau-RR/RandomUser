//
//  MainViewModel.swift
//  RandomUser
//
//  Created by Arnau on 10/06/2026.
//

import Combine
import Foundation
import SwiftData

@MainActor
final class MainViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published private(set) var users: [User] = []
    @Published var usersSavedInDB: [UserEntity] = []
    @Published var isLoading: Bool = false
    @Published private(set) var error: Error? = nil
    
    // MARK: - Dependencies
    
    private let service: RandomUsersServicesProtocol
    private var modelContext: ModelContext?
    
    init(service: RandomUsersServicesProtocol? = nil) {
        self.service = service ?? RandomUsersServices()
    }
    
    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Getter / Setter
    
    func getUsersArray() -> [User] {
        return users
    }
    
    // MARK: - Other Functions
    
    func checkUsersStored() async {
        guard let modelContext else { return }

        do {
            usersSavedInDB = try modelContext.fetch(
                FetchDescriptor<UserEntity>()
            )
        } catch {
            print(error)
        }
    }
    
    func fetchUsers(userWantsMoreUsers: Bool = false) async {
        if userWantsMoreUsers || usersSavedInDB.isEmpty {
            isLoading = true
            error = nil
            
            do {
                users = try await service.fetchRandomUsers(resultsNumber: 20).results
                removeDuplicateUsers()
                saveUsersToDb()
            } catch {
                self.error = error
            }
            
            isLoading = false
        }
    }
    
    func removeDuplicateUsers() {
        var seenUUIDs = Set<String>()
        
        users = users.filter { user in
            seenUUIDs.insert(user.login.uuid).inserted
        }
        
        //Internal Explication: Set doesn't allow duplicate values, here we're saying is the Set value has to check every UUID to check if it's unique or not
    }
    
    func saveUsersToDb() {
        
        guard let context = modelContext else {
            return
        }
        
        for user in users {
            context.insert(
                UserEntity(
                    uuid: user.login.uuid,
                    firstName: user.name.first,
                    lastName: user.name.last,
                    email: user.email,
                    phone: user.phone,
                    gender: user.gender,
                    city: user.location.city,
                    state: user.location.state,
                    registeredDate: user.registered.date,
                    pictureURL: user.picture.large
                )
            )
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
