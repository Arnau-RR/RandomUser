//
//  AppConfig.swift
//  RandomUser
//
//  Created by Arnau on 10/06/2026.
//

import Foundation

enum AppConfig {
    static var apiKey: String {
        guard let apiKey = Bundle.main.object(
            forInfoDictionaryKey: "API_KEY"
        ) as? String,
        !apiKey.isEmpty,
        apiKey != ""
        else {
            fatalError("API_KEY not configured")
        }

        return apiKey
    }
}
