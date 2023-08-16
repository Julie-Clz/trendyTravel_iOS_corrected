//
//  TrendyTravelApp.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 26/06/2023.
//

import SwiftUI

@main
struct TrendyTravelApp: App {
    @StateObject var userVm = UserViewModel()
    @StateObject var destinationsVm = DestinationViewModel()
    @StateObject var activitiesVm = ActivityViewModel()
    @StateObject var reviewVm = ReviewViewModel()
    @StateObject var postVm = PostViewModel()
    var body: some Scene {
        WindowGroup {
//            SignUpView()
//            DestinationsListView(searchDestinations: destinationsVm.destinations)
            RouterView()
                .environmentObject(userVm)
                .environmentObject(destinationsVm)
                .environmentObject(activitiesVm)
                .environmentObject(reviewVm)
                .environmentObject(postVm)
//                .preferredColorScheme(.dark)
        }
    }
}
