//
//  ActivityViewModel.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 17/07/2023.
//

import Foundation

class ActivityViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var activities: [Activity] = []
    @Published var errorMessage = ""
    
//    init() {
//        let urlString = "https://trendytravel.onrender.com/activities"
//        guard let url = URL(string: urlString)
//        else {
//            self.isLoading = false
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 400 {
//                    self.isLoading = false
//                    self.errorMessage = "Bad status: \(statusCode)"
//                    return
//                }
//
//                guard let data = data else { return }
//                do {
//                    self.activities = try JSONDecoder().decode([Activity].self, from: data)
//                } catch {
//                    print("Failed to decode JSON: ", error)
//                    self.errorMessage = error.localizedDescription
//                }
//                self.isLoading = false
//            }
//        }.resume()
//    }
    
    func getActivities(url: String) -> [Activity] {
        guard let url = URL(string: url) else {
//            self.isLoading = false
            return activities
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 400 {
                    self.isLoading = false
                    self.errorMessage = "Bad status: \(statusCode)"
                    return
                }
                guard let data = data else { return }
                do {
                self.activities = try JSONDecoder().decode([Activity].self, from: data)
                } catch let jsonError {
                    print("Decoding failed for activities ALL:", jsonError)
                }
                self.isLoading = false
            }
        }.resume()
//        print(activities)
        return activities
    }
}
