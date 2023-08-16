//
//  UserDetailsView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 26/06/2023.
//

import SwiftUI

struct UserDetailsView: View {
    let user: User
    @EnvironmentObject var postVm: PostViewModel
    @EnvironmentObject var userVm: UserViewModel
    @State private var isFollowedByCurrentUser = false
    @State private var userFollowers: Int = 0
    @State private var totalLikes = 0
    @State private var postLikes = 0
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                AsyncImage(url: URL(string: user.profilImage)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(
                            Circle()
                                .stroke(Color.cyan.opacity(0.6), lineWidth: 2)
                                .frame(width: 80, height: 80)
                        )
                } placeholder: {
                    //                    Image("sam")
                    //                        .resizable()
                    //                        .scaledToFit()
                    //                        .frame(width: 80)
                    //                        .clipShape(Circle())
                    //                        .shadow(radius: 10)
                    //                        .overlay(
                    //                            Circle()
                    //                                .stroke(Color.cyan.opacity(0.6), lineWidth: 2)
                    //                                .frame(width: 80, height: 80)
                    //                        )
                    ProgressView()
                }
                Text("\(user.firstName.capitalized) \(user.lastName.capitalized)")
                    .font(.system(size: 14, weight: .semibold))
                    .onAppear {
                        for follower in (user.followers) {
                            if follower.followerID == userVm.currentUser.id && follower.followedID == user.id {
                                self.isFollowedByCurrentUser = true
                                self.userFollowers = user.followers.count
                            } else {
                                self.isFollowedByCurrentUser = false
                                self.userFollowers = user.followers.count
                            }
                        }
                        Task {
                            postVm.posts = try await postVm.getPosts(url: baseURL + "posts")
                        }
                        totalLikes = postVm.likesCalculationForUserPosts(user: user)
                    }
                HStack {
                    Text("@\(user.pseudo) •")
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.system(size: 10, weight: .semibold))
                    //-MARK: TOTAL LIKES
                    Text("\(totalLikes)")
                }
                .font(.system(size: 12, weight: .regular))
                
                Text(user.description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(.lightGray))
                
                HStack(spacing: 12) {
                    VStack {
                        //-MARK: TOTAL FOLLOWERS
                        Text("\(userFollowers)")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Followers")
                            .font(.system(size: 9, weight: .regular))
                    }
                    Spacer()
                        .frame(width: 0.5, height: 12)
                        .background(Color(.lightGray))
                    VStack {
                        //-MARK: TOTAL FOLLOWED
                        Text("\(userVm.followedCalculationForUser(userId: user.id))")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Following")
                            .font(.system(size: 9, weight: .regular))
                    }
                }
                HStack(spacing: 12) {
                    //-MARK: Follow or Unfollow a user
                    Button(action: {
                        if !isFollowedByCurrentUser {
                            Task {
                                try await userVm.followUser(url: baseURL + "followers", followerId: userVm.currentUser.id, followedId: user.id)
                                self.isFollowedByCurrentUser = true
                                self.userFollowers += 1
                            }
                        } else {
                            for follower in user.followers {
                                if follower.followerID == userVm.currentUser.id && follower.followedID == user.id {
                                    Task {
                                        try await userVm.UnfollowUser(url: baseURL + "followers/", id: follower.id)
                                    }
                                    self.isFollowedByCurrentUser = false
                                    self.userFollowers -= 1
                                }
                            }
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text(isFollowedByCurrentUser ? "Unfollow" : "Follow")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .background(Color.cyan)
                        .cornerRadius(50)
                    }
                    Button(action: {}) {
                        HStack {
                            Spacer()
                            Text("Contact")
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .background(Color(white: 0.9))
                        .cornerRadius(50)
                    }
                }
                .font(.system(size: 12, weight: .semibold))
                
                ForEach(user.posts.sorted(by: { post1, post2 in
                    post1.id > post2.id
                }), id: \.self) { post in
                    VStack(alignment: .leading) {
                        AsyncImage(url: URL(string: post.imageName)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }

                        HStack(alignment: .top) {
                            AsyncImage(url: URL(string: user.profilImage)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 34)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                            .onAppear {
                                postLikes = postVm.likesCalculationForUserPosts(postId: post.id, userId: user.id)
                            }
                                
                            VStack(alignment: .leading) {
                                Text(post.title)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.black)
                                HStack {
                                    ForEach(post.hashtags, id: \.self) { hashtag in
                                        Text("#\(hashtag)")
                                            .foregroundColor(Color.purple)
                                            .font(.system(size: 11, weight: .semibold))
                                            .padding(.horizontal, 11)
                                            .padding(.vertical, 2)
                                            .background(Color.purple.opacity(0.2))
                                            .cornerRadius(20)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 8)
                       
                        HStack {
                    //-MARK: ADD or REMOVE POST LIKE
                            Button {
                                for poste in postVm.posts {
                                    if poste.id == post.id {
                                        if let likes = poste.likes {
                                            for like in likes {
                                                if like.userId == userVm.currentUser.id {
                                                    Task {
                                                        try await postVm.unlikePost(url: baseURL + "likes/", id: like.id)
                                                    }
                                                    totalLikes -= 1
                                                    postLikes -= 1
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                                totalLikes = postVm.likesCalculationForUserPosts(user: user)
                                postLikes = postVm.likesCalculationForUserPosts(postId: post.id, userId: user.id)
                            } label: {
                                    Image(systemName: "hand.thumbsdown.fill")
                                        .foregroundColor(.cyan)
                                    .font(.system(size: 12))
                            }
                            Button {
                                if let likes = post.likes {
                                    for like in likes {
                                        if like.userId != userVm.currentUser.id {
                                            Task {
                                                try await postVm.likePost(url: baseURL + "likes", postId: post.id, userId: userVm.currentUser.id)
                                            }
                                        }
                                    }
                                }
                                
                                if post.likes == nil {
                                    Task {
                                        try await postVm.likePost(url: baseURL + "likes", postId: post.id, userId: userVm.currentUser.id)
                                    }
                                }
                                totalLikes = postVm.likesCalculationForUserPosts(user: user)
                                postLikes = postVm.likesCalculationForUserPosts(postId: post.id, userId: user.id)
                            } label: {
                                Image(systemName: "hand.thumbsup.fill")
                                    .foregroundColor(.cyan)
                                    .font(.system(size: 12))
                            }
                            //-MARK: POST LIKES
                            Text("\(postLikes) likes")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 6)
                    }
                    .background(Color(white: 1))
                    .cornerRadius(12)
                    .shadow(color: .init(white: 0.8), radius: 5, x: 0, y: 4)
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitle("\(user.pseudo)",  displayMode: .inline)
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserDetailsView(user: User(id: 0, firstName: "john", lastName: "doe", description: "hello I'm new", profilImage: "billy", pseudo: "jo.D", password: "kkk", email: "jo.d@gmail.com", posts: [Post(id: 0, title: "1st post", imageName: "eiffel_tower", hashtags: ["paradise", "lost"], userId: 0)], followers: [Follower(id: 1, followerID: 2, followedID: 0)]))
                .environmentObject(PostViewModel())
                .environmentObject(UserViewModel())
        }
    }
}
