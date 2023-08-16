//
//  PopularDestinationsDetailsView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 17/07/2023.
//

import SwiftUI
import MapKit


struct PopularDestinationsDetailsView: View {
    let destination: Destination
    @State var region: MKCoordinateRegion
    @State var isShowingAttractions = true
    
    init(destination: Destination) {
        self.destination = destination
        self.region = MKCoordinateRegion(center: .init(latitude: destination.latitude, longitude: destination.longitude), span: .init(latitudeDelta: 0.07, longitudeDelta: 0.07))
    }
    
    func activityImages(destination: Destination) -> [String] {
        var images: [String] = []
        for activity in  destination.activities {
                images.append(activity.imageName)
            }
        return images.reversed()
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            CarouselHeaderView(images: activityImages(destination: destination))
                .frame(height: 250)
                .padding(.top, 30)
                
            HStack {
                VStack(alignment: .leading) {
                    Text(destination.city.capitalized)
                        .font(.system(size: 18, weight: .bold))
                    Text(destination.country.capitalized)
                }
                Spacer()
                HStack {
                    ForEach(0..<5, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                    }
                }
            }
            .padding(.horizontal)
            HStack {
                Text("Lieux culturels")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                Button(action: {
                    isShowingAttractions.toggle()
                }) {
                    Text("\(isShowingAttractions ? "Masquer" : "Afficher")")
                        .font(.system(size: 12, weight: .semibold))
                }
                Toggle("", isOn: $isShowingAttractions)
                    .labelsHidden()
                    .tint(.cyan)
            }
            .padding()
            Map(coordinateRegion: $region, annotationItems: isShowingAttractions ? destination.activities : []) { activity in
                    MapAnnotation(coordinate: .init(latitude: activity.latitude, longitude: activity.longitude)) {
                        NavigationLink {
                            RestaurantDetailsView(restaurant: activity)
                        } label: {
                            CustomMapAnnotation(activity: activity)
                        }
                    }

               
            }
            .frame(height: 300)
          
        }
        .navigationBarTitle(destination.city.capitalized, displayMode: .inline)
    }
}

struct CustomMapAnnotation: View {
    let activity: Activity
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: activity.imageName)) { image in
                image
                    .resizable()
                    .frame(width: 50, height: 30)
                    .cornerRadius(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.init(white: 0, alpha: 0.5)))
                    )
            } placeholder: {
                ProgressView()
            }
          
            Text(activity.name.capitalized)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.mint]), startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(.init(white: 0, alpha: 0.5)))
                )
        }
        .shadow(radius: 5)
    }
}
