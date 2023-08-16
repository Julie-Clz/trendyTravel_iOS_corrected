//
//  TrendingCreatorsView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 26/06/2023.
//

import SwiftUI

struct TrendingCreatorsView: View {
    @EnvironmentObject var vm: UserViewModel
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Trendy Travellers")
                    .font(.system(size: 14, weight: .semibold))
                    .onAppear {
                        Task {
                            vm.users = try await vm.getUsers(url: baseURL + "users")
                        }
                        print(vm.users)
                    }
                Spacer()
                NavigationLink {
                    UsersListView(searchTravellers: vm.users)
                } label: {
                    Text("Tout voir")
                        .font(.system(size: 12, weight: .semibold))
                }
            }
            .foregroundColor(.black)
            .padding(.top)
          
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 15) {
                    ForEach(vm.users.sorted(by: { user1, user2 in
                        user1.followers.count > user2.followers.count
                    })) { user in
                        if vm.currentUser.id != user.id {
                            NavigationLink {
                                UserDetailsView(user: user)
                            } label: {
                                DiscoverUserView(user: user)
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.bottom)
            }
        }
        .padding(.horizontal)
    }
}

struct DiscoverUserView: View {
    let user: User
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: user.profilImage)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(.infinity)
            } placeholder: {
                ProgressView()
            }
            Text("@\(user.pseudo.capitalized)")
                .font(.system(size: 11, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
        }
//        .frame(width: 60)
//        .shadow(color: .gray, radius: 2, x: 0, y: 2)
    }
}

struct TrendingCreatorsView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingCreatorsView()
            .environmentObject(UserViewModel())
    }
}
