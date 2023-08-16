//
//  SearchView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 21/07/2023.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.isSearching) var isSearching
    @EnvironmentObject var vmDestination: DestinationViewModel
    @Binding var searchText: String
    @Binding var searchDestinations: [Destination]
    let gridItems: [GridItem] = [
        GridItem(.flexible(minimum: 100, maximum: 200)),
        GridItem(.flexible())
    ]
    var body: some View {
        VStack(alignment: .center) {
            if searchDestinations.isEmpty {
                    Text("Oops... Nous n'avons trouvé aucune destination correspondant à votre recherche 🥵")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.title3)
                        .lineLimit(4)
                        .padding()
                        .padding(.top, 100)
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: gridItems, spacing: 8) {
                        ForEach(searchDestinations, id: \.self) { destination in
                            NavigationLink {
                                PopularDestinationsDetailsView(destination: destination)
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
        }
        .onAppear {
            vmDestination.destinations = vmDestination.getDestinations(url: baseURL + "destinations")
            searchDestinations = vmDestination.getDestinations(url: baseURL + "destinations")
        }
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchText: .constant(""), searchDestinations: .constant(DestinationViewModel().destinations))
            .environmentObject(DestinationViewModel())
    }
}
