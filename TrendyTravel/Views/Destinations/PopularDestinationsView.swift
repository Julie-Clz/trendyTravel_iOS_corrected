//
//  PopularDestinationsView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 26/06/2023.
//

import SwiftUI

struct PopularDestinationsView: View {
    @EnvironmentObject var vm: DestinationViewModel
    var body: some View {
        VStack {
            HStack {
                Text("Trendy Destinations")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                NavigationLink {
                    DestinationsCardsView(searchDestinations: vm.destinations)
                } label: {
                    Text("Tout voir")
                        .font(.system(size: 12, weight: .semibold))
                }
            }
            .foregroundColor(.black)
            .padding(.horizontal)
            .padding(.top)
            .onAppear {
                vm.destinations = vm.getDestinations(url: baseURL + "destinations")
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    if vm.destinations.count >= 5 {
                        ForEach(vm.destinations.sorted(by: { destination1, destination2 in
                            vm.destinationAverageRating(destination: destination1) > vm.destinationAverageRating(destination: destination2)
                        }).prefix(upTo: 5)) { destination in
                            NavigationLink {
                                PopularDestinationsDetailsView(destination: destination)
                            } label: {
                                PopularDestinationTile(destination: destination)
                                    .padding(.bottom)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}


struct PopularDestinationTile: View {
    let destination: Destination
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: destination.imageName)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 125, height: 125)
                    .cornerRadius(4)
                    .padding(.all, 6)
            } placeholder: {
                ProgressView()
            }
            Text(destination.city.capitalized)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 12)
                .foregroundColor(.black)
            Text(destination.country.capitalized)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
                .foregroundColor(.gray)
        }
    }
}

struct PopularDestinationsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PopularDestinationsView()
                .environmentObject(DestinationViewModel())
        }
    }
}
