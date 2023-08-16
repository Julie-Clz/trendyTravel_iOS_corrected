//
//  TrendyTravelTests.swift
//  TrendyTravelTests
//
//  Created by Julie Collazos on 26/06/2023.
//

import XCTest
import SwiftUI
@testable import TrendyTravel

final class TrendyTravelTests: XCTestCase {
    @ObservedObject var userVm = UserViewModel()
    @ObservedObject var destinationVm = DestinationViewModel()
    @ObservedObject var activityVm = ActivityViewModel()
    @ObservedObject var reviewVm = ReviewViewModel()
    @ObservedObject var postVm = PostViewModel()
    var urlDBTEST = "http://localhost:8080/"
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //-MARK: DESTINATIONS
    func testGetDestinations() throws {
        let destinations: [Destination] = destinationVm.getDestinations(url: urlDBTEST + "destinations")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertNotEqual(destinations.count, 0)
            XCTAssertNotEqual(destinations.first!.city, "")
        }
    }
    
    //-MARK: ACTIVITIES
    func testGetActivities() throws {
        let activities: [Activity] = activityVm.getActivities(url: urlDBTEST + "activities")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertNotEqual(activities.count, 0)
            XCTAssertNotEqual(activities.first!.name, "")
        }
    }
    
    //-MARK: REVIEWS
    func testGetReviews() throws {
        let reviews: [Review] = reviewVm.getReviews(url: urlDBTEST + "reviews")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertNotEqual(reviews.count, 0)
            XCTAssertNotEqual(reviews.first!.content, "")
        }
    }
    
    //-MARK: POSTS
    func testGetPosts() throws {
        // GET POSTS INIT IN VM
        let posts: [Post] = postVm.posts
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertNotEqual(posts.count, 0)
            XCTAssertNotEqual(posts.first!.title, "")
        }
    }

    //-MARK: USERS
    func testGetUsers() async throws {
        let users: [User] = try await userVm.getUsers(url: urlDBTEST + "users")
        XCTAssertNotEqual(users.count, 0)
        XCTAssertNotEqual(users.first!.firstName, "")
    }
    
    func testGetCurrentUser() async throws {
        // CurrentUser id = 1
        let currentUser: User = try await userVm.getCurrentUser(url: urlDBTEST + "users/")
        XCTAssertNotEqual(currentUser.id, 0)
        XCTAssertEqual(currentUser.id, 1)
        XCTAssertNotEqual(currentUser.firstName, "")
        print(currentUser)
    }
    
//    func testFollowUser() async throws {
//        let users: [User] = try await userVm.getUsers()
//        let currentUser: User = try await userVm.getCurrentUser()
//        var follower: Follower
//        for user in users {
//            if user.id != currentUser.id {
//                follower = try await userVm.followUser(followerId: currentUser.id, followedId: user.id)
//                print("FOL: \(follower)")
//                XCTAssertEqual(follower.followedID, user.id)
//                XCTAssertEqual(follower.followerID, currentUser.id)
//                XCTAssertNotEqual(follower.followedID, follower.followerID)
//            }
//        }
//    }
    
//    func testUnfollowUser() async throws {
//        let users: [User] = try await userVm.getUsers()
//        let currentUser: User = try await userVm.getCurrentUser()
//        var follower: Follower
//        for user in users {
//            if user.id != currentUser.id {
//                for foll in user.followers {
//                    if foll.followerID == currentUser.id {
//                        follower = try await userVm.UnfollowUser(id: foll.id)
//                        print("FOL: \(follower)")
//                        XCTAssertNotEqual(foll.followedID, user.id)
//                        XCTAssertNotEqual(foll.followerID, currentUser.id)
//                    }
//                }
//
//
//
//
//            }
//        }
//    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
