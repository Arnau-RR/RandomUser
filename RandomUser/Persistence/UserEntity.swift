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
    
    var streetNumber: Int
    var streetName: String
    var city: String
    var state: String
    
    var latitude: String
    var longitude: String
    
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
        streetNumber: Int,
        streetName: String,
        city: String,
        state: String,
        latitude: String,
        longitude: String,
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
        self.streetNumber = streetNumber
        self.streetName = streetName
        self.city = city
        self.state = state
        self.latitude = latitude
        self.longitude = longitude
        self.registeredDate = registeredDate
        self.pictureURL = pictureURL
        self.isDeletedByUser = isDeletedByUser
    }
}
