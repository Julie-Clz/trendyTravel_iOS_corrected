//
//  Activity.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 17/07/2023.
//

import Foundation


//-MARK: Correction Categories structure
enum Category: String, CaseIterable, Hashable {
    case culture = "culture", events = "spectacle", sports = "sport", food = "restaurant", bar = "bar"
    
    var imageName: String {
        switch self {
        case .culture:
            return "books.vertical.fill"
        case .events:
            return "music.mic"
        case .sports:
            return "sportscourt.fill"
        case .food:
            return "fork.knife"
        case .bar:
            return "wineglass.fill"
        }
    }
}

// MARK: - Activity
struct Activity: Codable, Hashable, Identifiable {
    var id: Int
    var category: Category.RawValue
    var name: String
    var imageName: String
    var link: String
    var price: String
    var latitude, longitude: Double
    var description: String
    var rating, destinationId: Int
    var destination: DestinationActivity?

    enum CodingKeys: String, CodingKey {
        case id, category, name, imageName, link, price, latitude, longitude, description, rating
        case destinationId
        case destination = "Destination"
    }
}

struct DestinationActivity: Codable, Hashable, Identifiable {
    var id: Int
    var country, city: String
    var imageName: String
    var latitude, longitude: Double
}
