//
//  DestinationsCardsView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 17/07/2023.
//

import SwiftUI

struct DestinationsCardsView: View {
    @EnvironmentObject var vmDestination: DestinationViewModel
    @State var searchText = ""
    @State var searchDestinations: [Destination]
    let gridItems: [GridItem] = [
        GridItem(.flexible(minimum: 100, maximum: 200)),
        GridItem(.flexible())
    ]
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: gridItems, spacing: 8) {
                    ForEach(searchDestinations, id: \.self) { destination in
                        NavigationLink {
                            PopularDestinationsDetailsView(destination: destination)
                                .onAppear {
                                    vmDestination.destinations = vmDestination.getDestinations(url: baseURL + "destinations")
                                    searchDestinations = vmDestination.getDestinations(url: baseURL + "destinations")
                                }
                        } label: {
                            PopularDestinationTile(destination: destination)
                                .background(Color.white)
                                .cornerRadius(16)
                                .padding(.top, 32)
                                .padding(.bottom)
                        }
                    }
                    .padding(.horizontal)
                }
                
            }
        }
        .background( LinearGradient(gradient: Gradient(colors: [.cyan, .mint]), startPoint: .top,
                                    endPoint: .center)
            .ignoresSafeArea())
//        .navigationTitle("Destinations")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt:
                        Text("Où voulez-vous aller ?")
        )
        .foregroundColor(.white)
        .fontWeight(.bold)
        .onChange(of: searchText.lowercased()) { destination in
            if !destination.isEmpty {
                searchDestinations = vmDestination.destinations.filter {
                    $0.city.lowercased().contains(destination) ||  $0.country.lowercased().contains(destination)
                }
            } else {
                searchDestinations = vmDestination.destinations
            }
        }
    }
}

struct DestinationsCardsView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationsCardsView(searchDestinations: DestinationViewModel().destinations)
            .environmentObject(DestinationViewModel())
    }
}
