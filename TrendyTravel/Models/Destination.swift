//
//  Destinations.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 26/06/2023.
//

import Foundation


//-MARK: Erreur Categories structure
//struct Category: Hashable {
//    let name, imageName: String
//}

//struct Restaurant: Hashable {
//    let name, image: String
//}

// MARK: - Destination
struct Destination: Codable, Hashable, Identifiable {
    var id: Int
    var country, city: String
    var imageName: String
    var latitude, longitude: Double
    var activities: [Activity]

    enum CodingKeys: String, CodingKey {
        case id, country, city, imageName, latitude, longitude
        case activities = "Activities"
    }
}
