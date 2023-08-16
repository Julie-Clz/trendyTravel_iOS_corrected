//
//  ProfileImageView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 25/07/2023.
//

import SwiftUI
import PhotosUI

struct ProfileImageView: View {
    @State var profilImageSeclected: PhotosPickerItem?
    @State private var profilImage: Image?
    @Binding var image: UIImage?
    @EnvironmentObject var viewModel: PostViewModel
    
    var body: some View {
           ZStack {
//               Circle()
//                   .frame(width: 100, height: 100)
               Circle()
                   .foregroundColor(.white)
                   .frame(width: 100, height: 100)
                   .overlay {
                       VStack {
                           Spacer()
                           PhotosPicker("Photo", selection: $profilImageSeclected, matching: .images)
                               .font(.caption)
                               .fontWeight(.bold)
                               .foregroundColor(.white)
                               .padding(.bottom)
                               .padding(.horizontal, 30)
                               .background(Color.cyan)
                       }
                   }
                   .cornerRadius(75)
                   .shadow(radius: 5, x: 0, y: 5)
               
               if let profilImage {
                   profilImage
                       .resizable()
                       .scaledToFill()
                       .frame(width: 100, height: 100)
                       .overlay {
                           VStack {
                               Spacer()
                               PhotosPicker("Photo", selection: $profilImageSeclected, matching: .images)
                                   .font(.caption)
                                   .fontWeight(.bold)
                                   .foregroundColor(.white)
                                   .padding(.bottom)
                                   .padding(.horizontal, 30)
                                   .background(Color.cyan)
                           }
                       }
                       .cornerRadius(75)
                       .shadow(radius: 5, x: 0, y: 5)
               }
           }
           .onChange(of: profilImageSeclected) { _ in
               Task {
                   if let data = try? await profilImageSeclected?.loadTransferable(type: Data.self) {
                       if let uiImage = UIImage(data: data) {
                           profilImage = Image(uiImage: uiImage)
                           image = uiImage
                           return
                       }
                   }

                   print("Failed")
               }
           }
       }
}


struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView(image: .constant(UIImage(named: "")))
            .environmentObject(PostViewModel())
//            .background(Color.cyan)
    }
}
