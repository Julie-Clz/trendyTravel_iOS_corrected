//
//  CategoryDetailView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 26/06/2023.
//

import SwiftUI

struct CategoryDetailView: View {
    let name: String
    @EnvironmentObject var activityVm: ActivityViewModel
    @EnvironmentObject var destinationVm: DestinationViewModel
    var body: some View {
        ScrollView {
            ForEach(activityVm.activities.sorted(by: { activity1, activity2 in
                activity1.rating > activity2.rating
            })) { activity in
                if activity.category == name {
                    CategoryDetailCardView(activity: activity)
                        .navigationBarTitle(activity.category.capitalized, displayMode: .inline)
                }
            }
        }
    }
}


struct CategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoryDetailView(name: Category.food.rawValue)
                .environmentObject(ActivityViewModel())
                .environmentObject(DestinationViewModel())
        }
    }
}

struct CategoryDetailCardView: View {
    let activity: Activity
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationLink {
                RestaurantDetailsView(restaurant: activity)
            } label: {
                VStack(alignment: .leading) {
                    AsyncImage(url: URL(string: activity.imageName)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text(activity.name.capitalized)
                                .font(.system(size: 14, weight: .semibold))
                                .padding(.bottom, 5)
                            Text(activity.destination?.city.capitalized ?? "")
                                .font(.system(size: 12, weight: .medium))
                            Text(activity.destination?.country.capitalized ?? "")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom)
                        Spacer()
                        
                        Text(activity.category.capitalized)
                            .foregroundColor(Color.cyan)
                            .font(.system(size: 13, weight: .semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 2)
                            .background(Color.cyan.opacity(0.2))
                            .cornerRadius(20)
                            .padding(.trailing)
                    }
                    .padding(.horizontal, 8)
                }
                .background(Color(white: 1))
                .cornerRadius(12)
                .shadow(color: .secondary, radius: 5, x: 0, y: 4)
            }
        }
        .padding()
    }
}

struct CategoryDetailCardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoryDetailCardView(activity: ActivityViewModel().activities.first ?? Activity(id: 0, category: Category.culture.rawValue, name: "Tour Eiffel", imageName: "eiffel_tower", link: "http/toureiffel.fr", price: "€€", latitude: 10.32, longitude: 49.5, description: "Monument bla bla bla", rating: 5, destinationId: 1))
                .environmentObject(ActivityViewModel())
                .environmentObject(DestinationViewModel())
        }
    }
}
