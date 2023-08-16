//
//  RouterView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 25/07/2023.
//

import SwiftUI

struct RouterView: View {
    @StateObject var userVm = UserViewModel()
    @StateObject var destinationsVm = DestinationViewModel()
    @StateObject var activitiesVm = ActivityViewModel()
    @StateObject var reviewVm = ReviewViewModel()
    @StateObject var postVm = PostViewModel()
    @State var isLoggedIn: Bool = false
    var body: some View {
        if UserDefaults.standard.string(forKey: "UserId") != nil {
            DestinationsListView(searchDestinations: destinationsVm.destinations)
                .environmentObject(userVm)
                .environmentObject(destinationsVm)
                .environmentObject(activitiesVm)
                .environmentObject(reviewVm)
                .environmentObject(postVm)
                .onAppear {
                    print("Logger: \(userVm.currentUserId)")
                }
        } else {
            SignInView(isLoggedIn: $isLoggedIn)
                .environmentObject(userVm)
                .environmentObject(destinationsVm)
                .environmentObject(activitiesVm)
                .environmentObject(reviewVm)
                .environmentObject(postVm)
        }
        
    }
}

struct RouterView_Previews: PreviewProvider {
    static var previews: some View {
        RouterView()
    }
}
