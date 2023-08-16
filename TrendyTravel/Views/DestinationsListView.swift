//
//  DestinationsListView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 26/06/2023.
//

import SwiftUI

struct DestinationsListView: View {
    @EnvironmentObject var vmDestination: DestinationViewModel
    @EnvironmentObject var vmUser: UserViewModel
    @State var searchText = ""
    @State var searchDestinations: [Destination]
    @EnvironmentObject var vm: UserViewModel
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.cyan, .mint]), startPoint: .top,
                               endPoint: .center)
                .ignoresSafeArea()
                .onAppear {
                    Task {
                        vm.currentUserId = UserDefaults.standard.integer(forKey: "UserId")
                        vmUser.currentUser = try await vmUser.getCurrentUser(url: baseURL + "users/")
                    }
                }
                ScrollView(showsIndicators: false) {
                    DestinationsCategoriesView()
                        .padding(.top)
                    
                    if !searchText.isEmpty {
                        SearchView(searchText: $searchText, searchDestinations: $searchDestinations)
                    } else {
                        VStack {
                            PopularDestinationsView()
                            PopularRestaurantsView()
                            TrendingCreatorsView()
                        }
                        .padding(.bottom, 47)
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.top, 32)
                    }
                }
                .navigationTitle("")
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt:
                                Text("Où voulez-vous aller ?")
                )
                .foregroundColor(.white)
                .fontWeight(.bold)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Image("logo")
                            .resizable()
                            .scaledToFit()

                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            UserProfileView()
                        } label: {
                            AsyncImage(url: URL(string: vmUser.currentUser.profilImage)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40)
                                    .clipShape(Circle())
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .frame(width: 40)
                            }
                        }

                    }
                }
            }
        }
    }
}

struct DestinationsListView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationsListView(searchDestinations: [])
            .colorScheme(.light)
            .environmentObject(UserViewModel())
            .environmentObject(DestinationViewModel())
            .environmentObject(ActivityViewModel())
            .environmentObject(ReviewViewModel())
//        DestinationsListView(searchDestinations: [])
//            .colorScheme(.dark)
//            .environmentObject(UserViewModel())
//            .environmentObject(DestinationViewModel())
//            .environmentObject(ActivityViewModel())
//            .environmentObject(ReviewViewModel())
    }
}
