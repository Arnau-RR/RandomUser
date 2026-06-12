//
//  DuplicateTests.swift
//  RandomUser
//
//  Created by Arnau on 12/06/2026.
//

import XCTest
@testable import RandomUser

final class DuplicateTests: XCTestCase {
    
    @MainActor
    func testRemoveDuplicateUsersRemovesUsersWithSameUUID() {
        
        let vm = MainViewModel()
        
        let user1 = UserFactory.makeUser(uuid: "123")
        let user2 = UserFactory.makeUser(uuid: "123")
        let user3 = UserFactory.makeUser(uuid: "456")
        
        vm.setUsersForTesting([
            user1,
            user2,
            user3
        ])
        
        vm.removeDuplicateUsers()
        
        XCTAssertEqual(
            vm.getUsersArray().count,
            2
        )
    }
    
    @MainActor
    func testFetchUsersRemovesDuplicatesUsingService() async {
        
        let mockService = MockRandomUsersService()
        
        let user1 = UserFactory.makeUser(uuid: "123")
        let user2 = UserFactory.makeUser(uuid: "123")
        let user3 = UserFactory.makeUser(uuid: "456")
        
        mockService.usersToReturn = [
            user1,
            user2,
            user3
        ]
        
        let vm = MainViewModel(
            service: mockService
        )
        
        await vm.fetchUsers()
        
        XCTAssertEqual(
            vm.getUsersArray().count,
            2
        )
    }
}
