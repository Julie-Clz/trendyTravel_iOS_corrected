//
//  Posts.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 29/06/2023.
//

import Foundation

// MARK: - Post
struct Post: Codable, Hashable, Identifiable {
    var id: Int
    var title, imageName: String
    var hashtags: [String]
    var userId: Int
//    var createdAt, updatedAt: String
    var likes: [Like]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, imageName, hashtags
        case userId
//        case createdAt, updatedAt
        case likes = "Likes"
    }
}

// MARK: - PostElement
//struct PostElement: Codable {
//    var id: Int
//    var title, imageName: String
//    var hashtags: [String]
//    var userID: Int
//    var createdAt, updatedAt: String
//    var likes: [Like]
//
//    enum CodingKeys: String, CodingKey {
//        case id, title, imageName, hashtags
//        case userID = "userId"
//        case createdAt, updatedAt
//        case likes = "Likes"
//    }
//}

// MARK: - Like
struct Like: Codable, Hashable, Identifiable {
    var id, postId, userId: Int
    var createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case postId
        case userId
        case createdAt, updatedAt
    }
}

//typealias Post = [PostElement]
