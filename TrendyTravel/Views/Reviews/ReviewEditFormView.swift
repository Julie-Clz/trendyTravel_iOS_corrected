//
//  ReviewEditFormView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 21/07/2023.
//

import SwiftUI

struct ReviewEditFormView: View {
    @EnvironmentObject var reviewVm: ReviewViewModel
    @Environment(\.dismiss) var dismiss
    @State private var content = ""
    @State private var rating = 0
    var review: Review
  
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Text("Avis")
                        .foregroundColor(.gray.opacity(0.5))
                        .onAppear {
                            content = review.content
                            rating = review.rating
                        }
                    Spacer()
                    TextEditor(text: $content)
                        .frame(maxHeight: 100)
                }
                HStack {
                    Text("Note")
                        .foregroundColor(.gray.opacity(0.5))
                    Spacer()
                    RatingView(rating: $rating)
                }
                Section {
                    Button {
                        reviewVm.editReview(url: baseURL + "reviews/", id: review.id, content: content, rating: rating, activityId: review.activityId)
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Ajouter")
                            Spacer()
                        }
                    }
                    .padding()
                    .background(.cyan.opacity(0.8))
                    .cornerRadius(.infinity)
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                }
                .listRowBackground(Color.clear)
                .padding(.horizontal, 50)
                
            }
            .navigationTitle("Ajoute un avis")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ReviewEditFormView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewEditFormView(review: ReviewViewModel().reviews.first!)
            .environmentObject(ReviewViewModel())
    }
}
