//
//  ReviewViewModel.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 18/07/2023.
//

import Foundation

class ReviewViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    
    //-MARK: GET REVIEWS
    func getReviews(url: String) -> [Review] {
        guard let url = URL(string: url) else { return reviews }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else { return }
                do {
                    self.reviews = try JSONDecoder().decode([Review].self, from: data)
                } catch let jsonError {
                    print("Decoding failed for Reviews ALL:", jsonError)
                }
            }
        }.resume()
        return reviews
    }
    
    //-MARK: CREATE REVIEW
    func createReview(url: String, content: String, rating: Int, activityId: Int) {
        let body: [String: Any] = ["content" : content,
                                   "rating": rating,
                                   "userId": UserViewModel().currentUser.id,
                                   "activityId": activityId
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        // create post request
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        
        task.resume()
    }
    
    //-MARK: EDIT REVIEW
    func editReview(url: String, id: Int, content: String, rating: Int, activityId: Int) {
        let body: [String: Any] = ["content" : content,
                                   "rating": rating,
                                   "userId": UserViewModel().currentUser.id,
                                   "activityId": activityId
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        // create post request
        guard let url = URL(string: url + String(id)) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        // insert json data to the request
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        
        task.resume()
    }
    
    //-MARK: DELETE POST (ID)
    func deleteReview(url: String, id: Int) async throws -> (Review) {
        guard let url = URL(string: url + String(id))
        else {
            fatalError("Missing URL")
        }
        
        //        let body: [String: Int] = ["followerId" : followerId,
        //                                   "followedId" : followedId]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        //        urlRequest.httpBody = try? JSONEncoder().encode(body)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let review = try decoder.decode(Review.self, from: data)
        
        print("success delete: \(review)")
        return review
        
    }
    
}

