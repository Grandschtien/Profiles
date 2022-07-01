//
//  ProfilesModel.swift
//  Profiles
//
//  Created by Егор Шкарин on 30.06.2022.
//

import Foundation

// MARK: - Profiles
struct ProfilesModel: Codable {
    let profiles: [Profile]
    let info: Info
    
    enum CodingKeys: String, CodingKey {
        case profiles = "results"
        case info = "info"
    }
}

// MARK: - Info
struct Info: Codable {
    let seed: String?
    let results, page: Int
    let version: String?
}

// MARK: - Result
struct Profile: Codable {
    let gender: Gender
    let name: Name
    let location: Location
    let email: String
    let dob: Dob
    let picture: Picture
}

// MARK: - Dob
struct Dob: Codable {
    let date: String
    let age: Int
}

enum Gender: String, Codable {
    case female = "female"
    case male = "male"
}

// MARK: - Location
struct Location: Codable {
//    let street: Street?
//    let city, state, country: String?
//    let coordinates: Coordinates?
    let timezone: Timezone
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude, longitude: String
}

// MARK: - Street
struct Street: Codable {
    let number: Int
    let name: String
}

// MARK: - Timezone
struct Timezone: Codable {
    let offset, timezoneDescription: String

    enum CodingKeys: String, CodingKey {
        case offset
        case timezoneDescription = "description"
    }
}

// MARK: - Name
struct Name: Codable {
    let title, first, last: String
}

// MARK: - Picture
struct Picture: Codable {
    let large, medium, thumbnail: String
}
