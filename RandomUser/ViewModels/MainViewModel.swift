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
    
    // Delete Users
    @Published var userWantsDeleteUsers: Bool = false
    @Published var selectedDeletedUsers: [UserEntity] = []
    @Published var userConfirmsToDeleteTherUsers: Bool = false
    
    // Add Users
    @Published var userWantsMoreUsers: Bool = false
    @Published var userWantsToAddThisNumberOfUsers: String = "20"
    
    // Search Users
    @Published var userWantsSearchUsers: Bool = false
    @Published var searchText = ""
    
    // Error
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
            let descriptor = FetchDescriptor<UserEntity>(
                predicate: #Predicate<UserEntity> {
                    !$0.isDeletedByUser
                }
            )
            
            usersSavedInDB = try modelContext.fetch(descriptor)
            
        } catch {
            print(error)
        }
    }
    
    func fetchUsers(userWantsMoreUsers: Bool = false) async {
        if userWantsMoreUsers || usersSavedInDB.isEmpty {
            isLoading = true
            error = nil
            
            do {
                users = try await service.fetchRandomUsers(resultsNumber: Int(userWantsToAddThisNumberOfUsers) ?? 0).results
                removeDuplicateUsers()
                saveUsersToDb()
                await checkUsersStored()
            } catch {
                self.error = error
            }
            
            isLoading = false
        }
    }
    
    func removeDuplicateUsers() {
        //        var seenUUIDs = Set<String>()
        //
        //        users = users.filter { user in
        //            seenUUIDs.insert(user.login.uuid).inserted
        //        }
        
        let existingUUIDs = Set(usersSavedInDB.map(\.uuid))
        
        var seenUUIDs = existingUUIDs
        
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
                    streetNumber: user.location.street.number,
                    streetName: user.location.street.name,
                    city: user.location.city,
                    state: user.location.state,
                    latitude: user.location.coordinates.latitude,
                    longitude: user.location.coordinates.longitude,
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
    
    var filteredUsers: [UserEntity] {
        guard !searchText.isEmpty else {
            return usersSavedInDB
        }
        
        return usersSavedInDB.filter { user in
            user.firstName.localizedCaseInsensitiveContains(searchText) ||
            user.lastName.localizedCaseInsensitiveContains(searchText) ||
            user.email.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func userCellCheckBoxPressed(_ userSelected: UserEntity) {
        if let index = selectedDeletedUsers.firstIndex(where: { $0.uuid == userSelected.uuid }) {
            selectedDeletedUsers.remove(at: index)
        } else {
            selectedDeletedUsers.append(userSelected)
        }
    }
    
    func checkUsersAsDeleted() {
        
        guard let modelContext else { return }
        
        for user in selectedDeletedUsers {
            user.isDeletedByUser = true
        }
        
        do {
            try modelContext.save()
            
            selectedDeletedUsers.removeAll()
            
            Task {
                await checkUsersStored()
            }
            
        } catch {
            print(error)
        }
    }
}
