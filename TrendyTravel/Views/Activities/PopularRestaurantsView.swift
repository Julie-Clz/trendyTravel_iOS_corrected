//
//  PopularRestaurantsView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 26/06/2023.
//

import SwiftUI

struct PopularRestaurantsView: View {
    @EnvironmentObject var vm: ActivityViewModel
    var body: some View {
        VStack {
            HStack {
                Text("Trendy Restaurants")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                NavigationLink {
                    CategoryDetailView(name: Category.food.rawValue)
                } label: {
                    Text("Tout voir")
                        .font(.system(size: 12, weight: .semibold))
                }

            }
            .foregroundColor(.black)
            .padding(.horizontal)
            .padding(.top)
            .onAppear {
                vm.activities = vm.getActivities(url: baseURL + "activities")
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                        ForEach(vm.activities.sorted(by: { activity1, activity2 in
                            activity1.rating > activity2.rating
                        })) { restaurant in
                            if restaurant.category == Category.food.rawValue {
                                NavigationLink {
                                    RestaurantDetailsView(restaurant: restaurant)
                                } label: {
                                    RestaurantTile(restaurant: restaurant)
                                        .foregroundColor(Color(.label))
                                }
                                .padding(.bottom)
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct RestaurantTile: View {
    let restaurant: Activity
    var body: some View {
        HStack(spacing: 8) {
            AsyncImage(url: URL(string: restaurant.imageName)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipped()
                    .cornerRadius(5)
                    .padding(.leading, 6)
                    .padding(.vertical, 6)
            } placeholder: {
                ProgressView()
            }

          
            VStack(alignment: .leading, spacing: 6) {
//                HStack {
                    Text(restaurant.name)
                    .foregroundColor(.black)
//                    Spacer()
//                    Button(action: {}) {
//                        Image(systemName: "ellipsis")
//                            .foregroundColor(.gray)
//                    }
//                }
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                    Text("\(restaurant.rating)")
                        .foregroundColor(.gray)
                }
                Text("\(restaurant.destination?.city.capitalized ?? ""), \(restaurant.destination?.country.capitalized ?? "")")
                    .foregroundColor(.black)
            }
            .font(.system(size: 12, weight: .semibold))
            Spacer()
        }
    }
}

struct PopularRestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        PopularRestaurantsView()
            .environmentObject(ActivityViewModel())
    }
}
