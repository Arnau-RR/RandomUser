//
//  UserEntity.swift
//  RandomUser
//
//  Created by Arnau on 10/06/2026.
//

import SwiftData

@Model
final class UserEntity {

    @Attribute(.unique)
    var uuid: String

    var firstName: String
    var lastName: String
    var email: String
    var phone: String

    var gender: String
    var city: String
    var state: String
    var registeredDate: String

    var pictureURL: String

    var isDeletedByUser: Bool

    init(
        uuid: String,
        firstName: String,
        lastName: String,
        email: String,
        phone: String,
        gender: String,
        city: String,
        state: String,
        registeredDate: String,
        pictureURL: String,
        isDeletedByUser: Bool = false
    ) {
        self.uuid = uuid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.gender = gender
        self.city = city
        self.state = state
        self.registeredDate = registeredDate
        self.pictureURL = pictureURL
        self.isDeletedByUser = isDeletedByUser
    }
}
