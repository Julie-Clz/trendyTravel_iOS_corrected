//
//  UserProfileView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 19/07/2023.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var userVm: UserViewModel
    @EnvironmentObject var postVm: PostViewModel
    @State private var currentUser = User(id: 1, firstName: "julie", lastName: "clz", description: "Influenceuse, travelleuse ♥️", profilImage: "amy", pseudo: "julie.clz", password: "1234", email: "julie@mail.com", posts: [], followers: [])
    @State private var showPostModal = false
    @State private var showEditModal = false
    @State private var showRouterView = false
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                AsyncImage(url: URL(string: currentUser.profilImage)) { image in
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
                    Image("avatar")
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
//                    ProgressView()
                }
                .padding(.vertical)
                .onAppear {
                    Task {
                        postVm.posts = try await postVm.getPosts(url: baseURL + "posts")
                    }
                }
                Text("\(currentUser.firstName.capitalized) \(currentUser.lastName.capitalized)")
                    .font(.system(size: 14, weight: .semibold))
                HStack {
                    //-MARK: TOTAL LIKES
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.system(size: 10, weight: .semibold))
                    Text("\(postVm.likesCalculationForUserPosts(user: currentUser))")
                }
                .font(.system(size: 12, weight: .regular))
                
                Text(currentUser.description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(.lightGray))
                
                HStack(spacing: 12) {
                        VStack {
                            //-MARK: TOTAL FOLLOWERS
                            Text("\(currentUser.followers.count)")
                                .font(.system(size: 13, weight: .semibold))
                            Text("Followers")
                                .font(.system(size: 9, weight: .regular))
                        }
                    Spacer()
                        .frame(width: 0.5, height: 12)
                        .background(Color(.lightGray))
                    VStack {
                        //-MARK: TOTAL FOLLOWED
                        Text("\(userVm.followedCalculationForUser(userId: currentUser.id))")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Following")
                            .font(.system(size: 9, weight: .regular))
                    }
                }
                HStack(spacing: 70) {
                    Spacer()
                    Button(action: {
                        showPostModal.toggle()
                    }) {
                        HStack {
                            Spacer()
                            Text("Nouveau post")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .background(Color.cyan)
                        .cornerRadius(50)
                    }
                    .sheet(isPresented: $showPostModal) {
                        PostFormView()
                    }
                    Spacer()
                }
                .padding(.top)
                VStack(alignment: .leading) {
                    Text("Mes publications")
                        .fontWeight(.medium)
                    Divider()
                }
                .padding()
                .padding(.leading)
             
                ForEach(currentUser.posts.sorted(by: { post1, post2 in
                    post1.id > post2.id
                }), id: \.self) { post in
                    VStack(alignment: .leading) {
                            AsyncImage(url: URL(string: post.imageName)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width - 30, height: 200)
                                    .clipped()
                            } placeholder: {
                                ProgressView()
                        }

                        HStack(alignment: .top) {
                            AsyncImage(url: URL(string: currentUser.profilImage)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 34)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                                
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(post.title)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.black)
                                    Spacer()
                                    //-MARK: EDIT POST FORM
                                    Button {
                                        showEditModal.toggle()
                                    } label: {
                                        Image(systemName: "pencil.circle.fill")
                                            .foregroundColor(.cyan)
                                    }
                                    .sheet(isPresented: $showEditModal) {
                                        PostEditFormView(post: post)
                                    }
                                    //-MARK: DELETE POST
                                    Button {
                                        Task {
                                            try await postVm.deletePost(url: baseURL + "posts/", id: post.id)
                                        }
                                    } label: {
                                       Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                                HStack {
                                    ForEach(post.hashtags, id: \.self) { hashtag in
                                        Text("#\(hashtag)")
                                            .foregroundColor(Color.purple)
                                            .font(.system(size: 11, weight: .semibold))
                                            .padding(.horizontal, 11)
                                            .padding(.vertical, 2)
                                            .background(Color.purple.opacity(0.2))
                                            .cornerRadius(20)
                                            .lineLimit(2)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 5)
                       
                        HStack {
                                Image(systemName: "hand.thumbsup.fill")
                                    .foregroundColor(.cyan)
                                    .font(.system(size: 12))
                            //-MARK: POSTS LIKES
                            Text("\(postVm.likesCalculationForUserPosts(postId: post.id, userId: currentUser.id)) likes")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 6)
                    }
                    .background(Color(white: 1))
                    .cornerRadius(12)
                    .shadow(color: .init(white: 0.8), radius: 5, x: 0, y: 4)
                    .padding(.horizontal, 30)
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitle("@\(currentUser.pseudo.capitalized)",  displayMode: .inline)
        .toolbar {
            ToolbarItem {
                Button {
                    UserDefaults.standard.removeObject(forKey: "UserId")
                    showRouterView.toggle()
                } label: {
                    Text("Se déconnecter")
                        .foregroundColor(.cyan)
                        .font(.caption)
                }
                .fullScreenCover(isPresented: $showRouterView) {
                    RouterView()
                }
            }
        }
        .onAppear {
            Task {
                userVm.users = try await userVm.getUsers(url: baseURL + "users")
            }
            for user in (userVm.users) {
                if userVm.currentUserId == user.id {
                    currentUser = user
                }
               
            }
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UserProfileView()
                .environmentObject(UserViewModel())
                .environmentObject(PostViewModel())
        }
    }
}
