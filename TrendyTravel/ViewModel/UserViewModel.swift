//
//  UserViewModel.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 17/07/2023.
//

import Foundation

class UserViewModel: ObservableObject {
    
    @Published var users: [User] = []
    @Published var currentUserId: Int = UserDefaults.standard.integer(forKey: "UserId")
    @Published var currentUser: User = User(id: 0, firstName: "", lastName: "", description: "", profilImage: "", pseudo: "", password: "", email: "", posts: [], followers: [])
    
    //-MARK: CREATE USER - SIGN UP
    func createUser(url: String, firstName: String,  lastName: String, description: String, profilImage: String, pseudo: String, password: String, email: String) async throws -> Bool {
        let body: [String: Any] = ["firstName" : firstName,
                                   "lastName": lastName,
                                   "description": description,
                                   "profilImage": profilImage,
                                   "pseudo": pseudo,
                                   "password": password,
                                   "email": email
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        // create post request
        guard let url = URL(string: url) else { return false }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        UserDefaults.standard.removeObject(forKey: "UserId")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print("RESPONSE: \(responseJSON["id"]!)")
                UserDefaults.standard.set(responseJSON["id"], forKey: "UserId")
            }
        }
   
        task.resume()
      
        return true
    }
    
    //-MARK: SIGN IN
    func signIn(password: String, email: String) async -> Bool {
        var users = try? await getUsers(url: baseURL + "users")
        var emailAndPasswordIsValid = false
        
        if let users = users {
            for user in users {
                if email == user.email {
                    if password == user.password {
                        emailAndPasswordIsValid = true
                        UserDefaults.standard.removeObject(forKey: "UserId")
                        UserDefaults.standard.set(user.id, forKey: "UserId")
                        break
                    } else {
                        emailAndPasswordIsValid = false
                    }
                    
                } else {
                    emailAndPasswordIsValid = false
                }
            }
        }
        return emailAndPasswordIsValid
    }
    
    //-MARK: GET ALL USERS
    func getUsers(url: String) async throws -> [User] {
        guard let url = URL(string: url) else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decoder = JSONDecoder()
        let users = try decoder.decode([User].self, from: data)
        print("success users refresh !")
        return users
    }
    
    //-MARK: GET CURRENT USER
    func getCurrentUser(url: String) async throws -> User {
        guard let url = URL(string: url + String(currentUserId)) else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decoder = JSONDecoder()
        let currentUser = try decoder.decode(User.self, from: data)
        print("success users refresh !")
        return currentUser
    }
    
    //-MARK: FOLLOW USER
    func followUser(url: String, followerId: Int, followedId: Int) async throws {
        guard let url = URL(string: url)
        else {
            fatalError("Missing URL")
        }
       
        let body: [String: Int] = ["followerId" : followerId,
                                   "followedId" : followedId]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let follower = try decoder.decode(Follower.self, from: data)
        
        print("success follower created: \(follower)")
//        return follower
        
    }
    
    //-MARK: UNFOLLOW USER
    func UnfollowUser(url: String, id: Int) async throws {
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
        let _ = try decoder.decode(Follower.self, from: data)
        
        print("success delete follower with id: \(id)")
    }
    
    //-MARK: USER TOTAL FOLLOWED USERS ✅ (profile et user details view)
    func followedCalculationForUser(userId: Int) -> Int {
        var followed = 0
        for user in users {
            for userFollowed in user.followers {
                if userFollowed.followerID == userId {
                    followed += 1
                }
            }
        }
        return followed
    }
    
    //-MARK: IS USER FOLLOWED BY CURRENTUSER ✅ (usersListVIew)
    func followedUser(userId: Int) -> Bool {
        var isFollowed = false
        for user in users {
            if user.id == userId {
                for follower in user.followers {
                    if currentUser.id == follower.followerID {
                        isFollowed = true
                    }
                }
            }
        }
        return isFollowed
    }

}

