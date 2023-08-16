//
//  UsersListView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 19/07/2023.
//

import SwiftUI

struct UsersListView: View {
    @EnvironmentObject var vm: UserViewModel
    @State var searchTravellers: [User]
    @State private var searchText = ""
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.cyan, .mint]), startPoint: .top,
                                            endPoint: .center)
                             .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(searchTravellers.sorted(by: { user1, user2 in
                        user1.followers.count > user2.followers.count
                    })) { user in
                        if vm.currentUser.id != user.id {
                        NavigationLink {
                            UserDetailsView(user: user)
                        } label: {
                            HStack {
                                AsyncImage(url: URL(string: user.profilImage)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(.infinity)
                                } placeholder: {
                                    ProgressView()
                                }
                                VStack(alignment: .leading) {
                                    Text("@\(user.pseudo.capitalized)")
                                        .font(.system(size: 11, weight: .black))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                    Text(user.description)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                    HStack {
                                        Text("\(user.followers.count) follower(s)")
                                        Text(vm.followedUser(userId: user.id) ? " - suivi(e)" : "")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    }
                    Spacer()
                }
                .padding(.top)
                .navigationTitle("Travellers")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    Task {
                        vm.users = try await vm.getUsers(url: baseURL + "users")
                        searchTravellers = vm.users
                    }

            }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt:
                                Text("Traveller")
                )
                .onChange(of: searchText.lowercased()) { traveller in
                    if !traveller.isEmpty {
                        searchTravellers =  vm.users.filter {
                            $0.firstName.lowercased().contains(traveller) ||  $0.pseudo.lowercased().contains(traveller)
                        }
                    } else {
                        searchTravellers =  vm.users
                    }
                }
            
            }
        }
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UsersListView(searchTravellers: UserViewModel().users)
                .environmentObject(UserViewModel())
        }
    }
}
