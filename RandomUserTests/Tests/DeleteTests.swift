//
//  DeleteTests.swift
//  RandomUser
//
//  Created by Arnau on 12/06/2026.
//

import XCTest
@testable import RandomUser

final class DeleteTests: XCTestCase {
    
    @MainActor
    func testDeletedUserDoesNotAppearInFilteredUsers() {
        
        let vm = MainViewModel()
        
        let user = UserEntityFactory.makeUser(firstName: "John")
        user.isDeletedByUser = false
        vm.usersSavedInDB = [user]
        
        user.isDeletedByUser = true
        vm.usersSavedInDB = vm.usersSavedInDB.filter { !$0.isDeletedByUser }
        
        XCTAssertTrue(vm.filteredUsers.isEmpty)
    }
    
    @MainActor
    func testDeletedUserDoesNotReappearAfterFetch() {
        
        let vm = MainViewModel()
        
        let deletedUser = UserEntityFactory.makeUser(uuid: "123", firstName: "John")
        deletedUser.isDeletedByUser = true
        vm.usersSavedInDB = [deletedUser]
        
        vm.setUsersForTesting([
            UserFactory.makeUser(uuid: "123", firstName: "John")
        ])
        
        vm.removeDuplicateUsers()
        
        XCTAssertTrue(vm.getUsersArray().isEmpty)
    }
}
