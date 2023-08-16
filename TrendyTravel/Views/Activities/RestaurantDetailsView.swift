//
//  RestaurantDetailsView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 29/06/2023.
//

import SwiftUI

struct RestaurantDetailsView: View {
    let restaurant: Activity
//    var reviews: [Review]
    var body: some View{
        ScrollView {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: restaurant.imageName)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .center, endPoint: .bottom)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(restaurant.name.capitalized)
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                        HStack {
                            ForEach(0..<restaurant.rating, id: \.self) { _ in
                                Image(systemName: "star.fill")
                            }
                            .foregroundColor(.orange)
                            ForEach(restaurant.rating..<5, id: \.self) { _ in
                                Image(systemName: "star.fill")
                            }
                            .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                }
                .padding()
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("\(restaurant.destination?.city.capitalized ?? ""), \(restaurant.destination?.country.capitalized ?? "")")
                    .font(.system(size: 16, weight: .bold))
                HStack {
                    Text(restaurant.price)
                    .foregroundColor(.orange)
                }
                HStack { Spacer() }
            }
            .padding(.top)
            .padding(.horizontal)
            Text(restaurant.description)
                .padding(.top, 8)
                .font(.system(size: 14, weight: .regular))
                .padding(.horizontal)
                .padding(.bottom)
            Divider()
                .padding(.horizontal)
            ReviewsListView(restaurant: restaurant)
                .padding(.top)
        }
        .navigationBarTitle(restaurant.name.capitalized, displayMode: .inline)
    }
}


//struct RestaurantDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            RestaurantDetailsView()
//        }
//    }
//}
