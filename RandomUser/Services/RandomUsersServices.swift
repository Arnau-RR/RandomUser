//
//  RandomUsersServices.swift
//  RandomUser
//
//  Created by Arnau on 10/06/2026.
//

import Foundation

protocol RandomUsersServicesProtocol {
    func fetchRandomUsers(resultsNumber: Int) async throws -> UsersResponse
}

final class RandomUsersServices: RandomUsersServicesProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchRandomUsers(resultsNumber: Int) async throws -> UsersResponse {

        let url = URL(
            string: "https://randomuser.me/api/?results=\(resultsNumber)"
        )!

        return try await apiClient.fetch(from: url, decoder: JSONDecoder())
    }
}
