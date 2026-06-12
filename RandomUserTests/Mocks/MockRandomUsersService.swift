//
//  MockRandomUsersService.swift
//  RandomUser
//
//  Created by Arnau on 12/06/2026.
//

import Foundation
@testable import RandomUser

final class MockRandomUsersService: RandomUsersServicesProtocol {

    var usersToReturn: [User] = []
    var shouldThrowError = false
    var delay: Duration = .seconds(0)
    var fetchCallCount = 0

    func fetchRandomUsers(
        resultsNumber: Int
    ) async throws -> UsersResponse {

        if delay > .seconds(0) {
            try await Task.sleep(for: delay)
        }

        fetchCallCount += 1

        if shouldThrowError {
            throw URLError(.notConnectedToInternet)
        }

        return UsersResponse(results: usersToReturn)
    }
}
