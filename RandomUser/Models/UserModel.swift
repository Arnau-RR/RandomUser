//
//  UserModel.swift
//  RandomUser
//
//  Created by Arnau on 10/06/2026.
//

import Foundation

struct UsersResponse: Codable {
    let results: [User]
    //let info: Info
}

struct User: Codable {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let login: Login
    let dob: DateInfo
    let registered: DateInfo
    let phone: String
    let cell: String
    let id: UserID
    let picture: Picture
    let nat: String
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
}

struct Location: Codable {
    let street: Street
    let city: String
    let state: String
    let country: String
    let postcode: Postcode
    let coordinates: Coordinates
    let timezone: Timezone
}

struct Street: Codable {
    let number: Int
    let name: String
}

enum Postcode: Codable {
    case int(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let intValue = try? container.decode(Int.self) {
            self = .int(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(
                Postcode.self,
                .init(codingPath: decoder.codingPath,
                      debugDescription: "Expected Int or String")
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .int(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
}

struct Coordinates: Codable {
    let latitude: String
    let longitude: String
}

struct Timezone: Codable {
    let offset: String
    let description: String
}

struct Login: Codable {
    let uuid: String
    let username: String
    let password: String
    let salt: String
    let md5: String
    let sha1: String
    let sha256: String
}

struct DateInfo: Codable {
    let date: String
    let age: Int
}

struct UserID: Codable {
    let name: String
    let value: String?
}

struct Picture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
}

//struct Info: Codable {
//    let seed: String
//    let results: Int
//    let page: Int
//    let version: String
//}
