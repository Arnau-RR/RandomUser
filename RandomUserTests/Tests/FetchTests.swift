//
//  FetchTests.swift
//  RandomUser
//
//  Created by Arnau on 12/06/2026.
//

import XCTest
@testable import RandomUser

final class FetchTests: XCTestCase {
    
    @MainActor
    func testFetchUsersStoresReturnedUsers() async {
        
        let mockService = MockRandomUsersService()
        
        let user1 = UserFactory.makeUser(uuid: "1")
        let user2 = UserFactory.makeUser(uuid: "2")
        let user3 = UserFactory.makeUser(uuid: "3")
        
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
            3
        )
    }
    
    @MainActor
    func testFetchUsersHandlesNetworkError() async {
        
        let mockService = MockRandomUsersService()
        mockService.shouldThrowError = true
        
        let vm = MainViewModel(service: mockService)
        
        await vm.fetchUsers()
        
        XCTAssertTrue(vm.getUsersArray().isEmpty)
        XCTAssertNotNil(vm.error)
    }
    
    @MainActor
    func testIsLoadingIsFalseAfterSuccessfulFetch() async {
        
        let mockService = MockRandomUsersService()
        mockService.usersToReturn = [
            UserFactory.makeUser(uuid: "1")
        ]
        
        let vm = MainViewModel(service: mockService)
        
        await vm.fetchUsers()
        
        XCTAssertFalse(vm.isLoading)
    }
    
    @MainActor
    func testIsLoadingIsFalseAfterFailedFetch() async {
        
        let mockService = MockRandomUsersService()
        mockService.shouldThrowError = true
        
        let vm = MainViewModel(service: mockService)
        
        await vm.fetchUsers()
        
        XCTAssertFalse(vm.isLoading)
    }
    
    @MainActor
    func testFetchUsersCallsServiceOnce() async {
        
        let mockService = MockRandomUsersService()
        let vm = MainViewModel(service: mockService)
        
        await vm.fetchUsers()
        
        XCTAssertEqual(mockService.fetchCallCount, 1)
    }
    
    @MainActor
    func testFetchUsersDoesNotCallServiceIfUsersAlreadyLoaded() async {
        
        let mockService = MockRandomUsersService()
        let vm = MainViewModel(service: mockService)
        
        vm.usersSavedInDB = [
            UserEntityFactory.makeUser(firstName: "John")
        ]
        
        await vm.fetchUsers()
        
        XCTAssertEqual(mockService.fetchCallCount, 0)
    }
    
    @MainActor
    func testFetchUsersCallsServiceWhenUserWantsMoreUsers() async {
        
        let mockService = MockRandomUsersService()
        let vm = MainViewModel(service: mockService)
        
        vm.usersSavedInDB = [
            UserEntityFactory.makeUser(firstName: "John")
        ]
        
        await vm.fetchUsers(userWantsMoreUsers: true)
        
        XCTAssertEqual(mockService.fetchCallCount, 1)
    }
}
