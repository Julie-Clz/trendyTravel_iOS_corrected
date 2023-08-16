//
//  ImagePostView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 20/07/2023.
//

import SwiftUI
import PhotosUI

struct ImagePostView: View {
    @State var postItem: PhotosPickerItem?
    @State private var postImage: Image?
    @Binding var image: UIImage?
    @ObservedObject var viewModel = PostViewModel()
    @Binding var imageToEdit: String
    var body: some View {
       VStack {
           if let postImage {
               postImage
                   .resizable()
                   .scaledToFill()
                   .frame(maxHeight: 100)
                   .padding()
           }
           
           if imageToEdit != "" && image == nil {
               AsyncImage(url: URL(string: imageToEdit)) { image in
                   image
                       .resizable()
                       .scaledToFill()
                       .frame(maxHeight: 100)
                       .padding()
               } placeholder: {
                   
               }
           }
           
           Section {
               HStack {
                   Spacer()
                   PhotosPicker((image != nil || imageToEdit != "") ? "Modifie la photo" : "Ajoute une photo", selection: $postItem, matching: .images)
                       .padding(10)
                       .background(.cyan.opacity(0.8))
                       .cornerRadius(.infinity)
                       .foregroundColor(.white)
                       .fontWeight(.medium)
                   Spacer()
               }
           }
           .listRowBackground(Color.clear)
           .padding(.bottom)
        }
       .onChange(of: postItem) { _ in
           Task {
               if let data = try? await postItem?.loadTransferable(type: Data.self) {
                   if let uiImage = UIImage(data: data) {
                       postImage = Image(uiImage: uiImage)
                       image = uiImage
                       return
                   }
               }

               print("Failed")
           }
       }
    }
}

struct ImagePostView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePostView(image: .constant(UIImage()), imageToEdit: .constant(""))
            .environmentObject(PostViewModel())
    }
}
