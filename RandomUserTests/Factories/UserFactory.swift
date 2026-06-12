//
//  UserFactory.swift
//  RandomUser
//
//  Created by Arnau on 12/06/2026.
//


import Foundation
@testable import RandomUser

enum UserFactory {

    static func makeUser(
        uuid: String = UUID().uuidString,
        firstName: String = "John",
        lastName: String = "Smith"
    ) -> User {

        User(
            gender: "male",
            name: Name(
                title: "Mr",
                first: firstName,
                last: lastName
            ),
            location: Location(
                street: Street(
                    number: 1,
                    name: "Main Street"
                ),
                city: "Barcelona",
                state: "Catalonia",
                country: "Spain",
                postcode: .int(12345),
                coordinates: Coordinates(
                    latitude: "0",
                    longitude: "0"
                ),
                timezone: Timezone(
                    offset: "+1",
                    description: "Spain"
                )
            ),
            email: "\(firstName.lowercased())@mail.com",
            login: Login(
                uuid: uuid,
                username: "",
                password: "",
                salt: "",
                md5: "",
                sha1: "",
                sha256: ""
            ),
            dob: DateInfo(
                date: "",
                age: 20
            ),
            registered: DateInfo(
                date: "",
                age: 1
            ),
            phone: "123456789",
            cell: "123456789",
            id: UserID(
                name: "",
                value: nil
            ),
            picture: Picture(
                large: "",
                medium: "",
                thumbnail: ""
            ),
            nat: "ES"
        )
    }
}