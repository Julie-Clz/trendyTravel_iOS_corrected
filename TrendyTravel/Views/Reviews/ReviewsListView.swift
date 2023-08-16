//
//  ReviewsListView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 18/07/2023.
//

import SwiftUI

struct ReviewsListView: View {
    @EnvironmentObject var reviewVm: ReviewViewModel
    @EnvironmentObject var userVm: UserViewModel
    var restaurant: Activity
    @State private var showAddReview = false
    @State private var showEditReview = false
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text("Avis des Travellers")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                    .onAppear {
                        reviewVm.reviews = reviewVm.getReviews(url: baseURL + "reviews")
                    }
                Button {
                    showAddReview.toggle()
                } label: {
                    Text("Ajouter un avis")
                        .padding(10)
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                        .font(.caption)
                        .background(.cyan)
                        .cornerRadius(.infinity)
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                .sheet(isPresented: $showAddReview) {
                    ReviewFormView(activityId: restaurant.id)
                }
                
            }
            .padding(.horizontal)
        }
        ForEach(reviewVm.reviews) { review in
            if review.userId == userVm.currentUser.id && restaurant.id == review.activity.id {
                VStack(alignment: .leading) {
                    HStack {
                        AsyncImage(url: URL(string: review.userElement.profilImage)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 44)
                                .clipShape(Circle())
                        }  placeholder: {
                            ProgressView()
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("@\(review.userElement.pseudo.capitalized)")
                                    .font(.system(size: 14,weight: .bold))
                                Spacer()
                                Button {
                                    showEditReview.toggle()
                                } label: {
                                    Image(systemName: "pencil.circle.fill")
                                        .foregroundColor(.cyan)
                                }
                                .padding(.trailing, 5)
                                .sheet(isPresented: $showEditReview) {
                                    ReviewEditFormView(review: review)
                                }
                                Button {
                                    Task {
                                        try await reviewVm.deleteReview(url: baseURL + "reviews/", id: review.id)
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }

                            }
                            HStack(spacing: 4) {
                                ForEach(0..<review.rating, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                }
                                .foregroundColor(.orange)
                                .font(.system(size: 12))
                                ForEach(review.rating..<5, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                }
                                .foregroundColor(.gray)
                            .font(.system(size: 12))
                       
                        Spacer()
                        Text("\(formatStringDateShort(date: review.createdAt))")
                            .font(.system(size: 14, weight: .bold))
                            }
                        }
                    }
                    Text(review.content)
                        .font(.system(size: 14, weight: .regular))
                }
                .padding(.horizontal)
            } else if restaurant.id == review.activity.id && review.userId != userVm.currentUser.id {
                VStack(alignment: .leading) {
                    HStack {
                        AsyncImage(url: URL(string: review.userElement.profilImage)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 44)
                                .clipShape(Circle())
                        }  placeholder: {
                            ProgressView()
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("@\(review.userElement.pseudo.capitalized)")
                                .font(.system(size: 14,weight: .bold))
                            HStack(spacing: 4) {
                                ForEach(0..<review.rating, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                }
                                .foregroundColor(.orange)
                                ForEach(review.rating..<5, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                }
                                .foregroundColor(.gray)
                            }
                            .font(.system(size: 12))
                        }
                        Spacer()
                        Text("\(formatStringDateShort(date: review.createdAt))")
                            .font(.system(size: 14, weight: .bold))
                    }
                    Text(review.content)
                        .font(.system(size: 14, weight: .regular))
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ReviewsListView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewsListView(restaurant: Activity(id: 4, category: Category.food.rawValue, name: "Big mamma", imageName: "art1", link: "http://fee ee e et", price: "€€", latitude: 50, longitude: 2, description: "restaurant italien", rating: 4, destinationId: 1))
            .environmentObject(ReviewViewModel())
            .environmentObject(UserViewModel())
    }
}
