//
//  UserEntityFactory.swift
//  RandomUser
//
//  Created by Arnau on 12/06/2026.
//

import Foundation
@testable import RandomUser

enum UserEntityFactory {

    static func makeUser(
        uuid: String = UUID().uuidString,
        firstName: String = "John",
        lastName: String = "Smith",
        email: String? = nil
    ) -> UserEntity {

        UserEntity(
            uuid: uuid,
            firstName: firstName,
            lastName: lastName,
            email: email ?? "\(firstName.lowercased())@mail.com",
            phone: "123456789",
            gender: "male",
            streetNumber: 1,
            streetName: "Main Street",
            city: "Barcelona",
            state: "Catalonia",
            latitude: "0",
            longitude: "0",
            registeredDate: "",
            pictureURL: ""
        )
    }
}
