//
//  Image.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 20/07/2023.
//

import Foundation
import SwiftUI

// MARK: - Data
struct DataImage: Codable {
    var data: String
}

//-MARK: Media
struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "imagefile.jpg"
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}
