//
//  DestinationsCategoriesImageAndLabelView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 26/06/2023.
//

import SwiftUI

struct DestinationsCategoriesImageAndLabelView: View {
    let image: String
    let title: String
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: image)
                .font(.system(size: 20))
                .foregroundColor(Color.cyan)
                .frame(width: 60, height: 60)
                .background(Color.white)
                .cornerRadius(.infinity)
            Text(title.capitalized)
                .font(.system(size: 10, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
        }
    }
}

struct DestinationsCategoriesImageAndLabelView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZStack {
                Color.cyan
                DestinationsCategoriesImageAndLabelView(image: "paintpalette.fill", title: "Art")
            }
        }
    }
}
