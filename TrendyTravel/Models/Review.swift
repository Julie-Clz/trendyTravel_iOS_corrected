//
//  Review.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 17/07/2023.
//

import Foundation

// MARK: - Review
struct Review: Codable, Hashable, Identifiable {
    var id: Int
    var content: String
    var rating, userId, activityId: Int
    var createdAt, updatedAt: String
    var activity: Activity
    var userElement: UserElement

    enum CodingKeys: String, CodingKey {
        case id, content, rating
        case userId
        case activityId
        case createdAt, updatedAt
        case activity = "Activity"
        case userElement = "User"
    }
}

// MARK: - User
struct UserElement: Codable, Hashable, Identifiable {
    var id: Int
    var firstName, lastName, profilImage: String
//    var pseudo, password, email: String
    var pseudo: String
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case profilImage, pseudo
//        case description, profilImage, pseudo, password, email
    }
}


