//
//  APIClientProtocol.swift
//  RandomUser
//
//  Created by Arnau on 10/06/2026.
//

import Foundation

protocol APIClientProtocol {
    func fetch<T: Decodable>(
        from url: URL,
        decoder: JSONDecoder
    ) async throws -> T
}

enum APIError: Error {
    case invalidResponse
    case invalidStatusCode(Int)
    case decodingError(Error)
}

final class APIClient: APIClientProtocol {

    func fetch<T: Decodable>(
        from url: URL,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidStatusCode(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }
}
