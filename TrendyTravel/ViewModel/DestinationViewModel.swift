//
//  DestinationViewModel.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 17/07/2023.
//

import Foundation

var baseURL = "https://trendytravel.onrender.com/"
//var baseURL = "http://localhost:8080/"

class DestinationViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var destinations: [Destination] = []

    //-MARK: GET ALL DESTINATIONS
    func getDestinations(url: String) -> [Destination] {
        guard let url = URL(string: "\(url)") else { return destinations }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else { return }
                do {
                    self.destinations = try JSONDecoder().decode([Destination].self, from: data)
                } catch let jsonError {
                    print("Decoding failed for Destinations ALL:", jsonError)
                }
            }
        }.resume()
        return destinations
    }
    
    //-MARK: DESTINATIONS AVERAGE RATING
    func destinationAverageRating(destination: Destination) -> Int {
        let activitiesNumber = destination.activities.count
        var activitiesRating = 0
        for activity in destination.activities {
            activitiesRating += activity.rating
        }
        if activitiesNumber != 0 {
            return (activitiesRating / activitiesNumber)
            
        } else {
            return 0
        }
    }
}
