//
//  PostViewModel.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 18/07/2023.
//

import Foundation
import UIKit

class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var postImage: String = ""
    @Published var image = UIImage()
    
    //-MARK: GET ALL POSTS
    func getPosts(url: String) async throws -> [Post] {
        guard let url = URL(string: url) else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decoder = JSONDecoder()
        let posts = try decoder.decode([Post].self, from: data)
//        print("success users refresh !")
        return posts
    }
    
    //-MARK: DELETE POST (ID)
    func deletePost(url: String, id: Int) async throws -> (Post) {
        guard let url = URL(string: baseURL + String(id))
        else {
            fatalError("Missing URL")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let post = try decoder.decode(Post.self, from: data)
        
        print("succes delete: \(post)")
        return post
        
    }
    
    //-MARK: ADD IMAGE
    func uploadImageToServer(url: String) -> String {
        let parameters = ["name": "MyTestFile123321",
                          "id": "12345"]
        guard let mediaImage = Media(withImage: image, forKey: "image") else { return "erreur media" }
        guard let url = URL(string: url) else { return "erreur url" }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //create boundary
        let boundary = generateBoundary()
        //set content type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        //call createDataBody method
        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
                let imageURL = try! JSONDecoder().decode(DataImage.self, from: data!)
                print(imageURL)
                
                self.postImage = imageURL.data
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
        return self.postImage
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: [String: Any]?, media: [Media]?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value as! String + lineBreak)")
            }
        }
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    
    //-MARK: CREATE POST
    func createPost(url: String, title: String, hashtags: [String], postImage: String) {
        let body: [String: Any] = ["title" : title,
                                   "imageName": postImage,
                                   "hashtags": hashtags,
                                   "userId": UserViewModel().currentUser.id
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
    
    //-MARK: EDIT POST
    func editPost(url: String, id: Int, title: String, hashtags: [String], postImage: String) {
        let body: [String: Any] = ["title" : title,
                                   "imageName": postImage,
                                   "hashtags": hashtags,
                                   "userId": UserViewModel().currentUser.id
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
    
    //-MARK: USERS POSTS TOTAL LIKES
    func likesCalculationForUserPosts(user: User) -> Int {
        var totalLikes = 0
        for post in posts {
            if post.userId == user.id {
                if let likes = post.likes {
                    totalLikes += likes.count
                }
            }
        }
        return totalLikes
    }
    
    //-MARK: USERS POST ID TOTAL LIKES
    func likesCalculationForUserPosts(postId: Int, userId: Int) -> Int {
        var totalLikes = 0
        for post in posts {
            if post.userId == userId && post.id == postId {
                if let likes = post.likes {
                    totalLikes = likes.count
                }
            }
        }
        return totalLikes
    }
    
    //-MARK: LIKE A POST
    func likePost(url: String, postId: Int, userId: Int) async throws {
        guard let url = URL(string: url)
        else {
            fatalError("Missing URL")
        }
       
        let body: [String: Int] = ["postId" : postId,
                                   "userId" : userId]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let postLike = try decoder.decode(Like.self, from: data)
        
        print("success post like added: \(postLike)")
    }
    
    //-MARK: UNLIKE A POST
    func unlikePost(url: String, id: Int) async throws {
        guard let url = URL(string: "\(url)\(id)")
        else {
            fatalError("Missing URL")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let _ = try decoder.decode(Like.self, from: data)
        
        print("success delete post like with id: \(id)")
    }
    
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
            print("data======>>>",data)
        }
    }
}
