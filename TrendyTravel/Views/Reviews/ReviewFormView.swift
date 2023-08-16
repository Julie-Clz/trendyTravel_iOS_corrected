//
//  ReviewFormView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 21/07/2023.
//

import SwiftUI

struct ReviewFormView: View {
    @EnvironmentObject var reviewVM: ReviewViewModel
    @Environment(\.dismiss) var dismiss
    @State private var content = ""
    @State private var rating = 0
    var activityId: Int
    var btnDisabled: Bool {
       if content == "" {
            return true
        }
        return false
    }
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Text("Avis")
                        .foregroundColor(.gray.opacity(0.5))
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
                        reviewVM.createReview(url: baseURL + "reviews", content: content, rating: rating, activityId: activityId)
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Ajouter")
                            Spacer()
                        }
                    }
                    .padding()
                    .background(btnDisabled ? .gray.opacity(0.2) : .cyan.opacity(0.8))
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

struct ReviewFormView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewFormView(activityId: 1)
            .environmentObject(ReviewViewModel())
    }
}
