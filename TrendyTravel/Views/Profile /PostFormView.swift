//
//  PostFormView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 19/07/2023.
//

import SwiftUI
import PhotosUI

struct PostFormView: View {
    @EnvironmentObject var postVm: PostViewModel
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var isHashtagFieldShow = false
    @State private var hashtag = ""
    @State private var hashtagArray: [String] = []
    @State private var image = UIImage(named: "")
    @State private var isLoading = false
    var btnDisabled: Bool {
        if isLoading {
            return true
        } else if title == "" {
            return true
        } else if hashtagArray.isEmpty {
            return true
        } else if image == UIImage(named: "") {
            return true
        }
        return false
    }
    var body: some View {
        Form {
            Section("Photo") {
                ImagePostView(image: $image, imageToEdit: .constant(""))
            }
            .listRowBackground(Color.clear)
            
            Section("Post") {
                TextField("Titre", text: $title, prompt: Text("Titre du post"))
            }
            
            Section("Hashtags") {
                VStack {
                    TextField("Hashtags", text: $hashtag, prompt: Text("Hashtag"))
                    Button {
                        hashtagArray.append(hashtag)
                        hashtag = ""
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Ajoute un hashtag")
                        }
                    }
                }
                ForEach(hashtagArray, id: \.self) { hash in
                    Text(hash)
                }
                .onDelete(perform: removeRows)
            }
            
            Section {
                Button {
                    Task {
                        if let image {
                            postVm.image = image
                        }
                        self.isLoading = true
                        postVm.postImage = postVm.uploadImageToServer(url: baseURL + "image")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0)  {
                        if postVm.postImage != "" {
                            postVm.createPost(url: baseURL + "posts", title: title, hashtags: hashtagArray, postImage: postVm.postImage)
                            self.isLoading = false
                            dismiss()
                        }
                        
                    }
                } label: {
                    HStack{
                        Spacer()
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Publier le post")
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(btnDisabled ? .gray.opacity(0.2) : .cyan.opacity(0.8))
                    .cornerRadius(.infinity)
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                }
                .disabled(btnDisabled)
            }
            .listRowBackground(Color.clear)
            
        }
        .navigationTitle("Publie un post")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func removeRows(at offsets: IndexSet) {
        hashtagArray.remove(atOffsets: offsets)
    }
}

struct PostFormView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PostFormView()
                .environmentObject(PostViewModel())
        }
    }
}
