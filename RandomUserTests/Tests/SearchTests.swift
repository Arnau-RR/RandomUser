//
//  SearchTests.swift
//  RandomUser
//
//  Created by Arnau on 12/06/2026.
//

import XCTest
@testable import RandomUser

final class SearchTests: XCTestCase {
    
    @MainActor
    func testFilteredUsersReturnsUsersMatchingFirstName() {
        
        let vm = MainViewModel()
        
        vm.usersSavedInDB = [
            UserEntityFactory.makeUser(
                firstName: "John"
            ),
            UserEntityFactory.makeUser(
                firstName: "Maria"
            )
        ]
        
        vm.searchText = "john"
        
        XCTAssertEqual(
            vm.filteredUsers.count,
            1
        )
        
        XCTAssertEqual(
            vm.filteredUsers.first?.firstName,
            "John"
        )
    }
    
    @MainActor
    func testFilteredUsersReturnsUsersMatchingEmail() {
        
        let vm = MainViewModel()
        
        vm.usersSavedInDB = [
            UserEntityFactory.makeUser(
                firstName: "John",
                email: "john@test.com"
            ),
            UserEntityFactory.makeUser(
                firstName: "Maria",
                email: "maria@test.com"
            )
        ]
        
        vm.searchText = "maria@test"
        
        XCTAssertEqual(
            vm.filteredUsers.count,
            1
        )
        
        XCTAssertEqual(
            vm.filteredUsers.first?.firstName,
            "Maria"
        )
    }
    
    @MainActor
    func testFilteredUsersReturnsAllUsersWhenSearchTextIsEmpty() {
        
        let vm = MainViewModel()
        
        vm.usersSavedInDB = [
            UserEntityFactory.makeUser(firstName: "John"),
            UserEntityFactory.makeUser(firstName: "Maria")
        ]
        
        vm.searchText = ""
        
        XCTAssertEqual(
            vm.filteredUsers.count,
            2
        )
    }
    
    @MainActor
    func testFilteredUsersIsCaseInsensitive() {
        
        let vm = MainViewModel()
        
        vm.usersSavedInDB = [
            UserEntityFactory.makeUser(firstName: "John")
        ]
        
        vm.searchText = "JOHN"
        
        XCTAssertEqual(
            vm.filteredUsers.count,
            1
        )
    }
}
