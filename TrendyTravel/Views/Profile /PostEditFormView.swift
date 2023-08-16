//
//  PostEditFormView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 20/07/2023.
//

import SwiftUI
import PhotosUI

struct PostEditFormView: View {
    @EnvironmentObject var postVm: PostViewModel
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var isHashtagFieldShow = false
    @State private var hashtag = ""
    @State private var hashtagArray: [String] = []
    @State private var image = UIImage(named: "")
    @State private var isLoading = false
    @State var post: Post
    @State var imageToEdit = ""
    var btnDisabled: Bool {
        if isLoading {
            return true
        } else if title == "" {
            return true
        } else if hashtagArray.isEmpty {
            return true
        }
        return false
    }
    var body: some View {
        Form {
            Section("Photo") {
                ImagePostView(image: $image, imageToEdit: $imageToEdit)
            }
            .listRowBackground(Color.clear)
            
            Section("Post") {
                TextField("Titre", text: $title, prompt: Text("Titre du post"))
                    .onAppear {
                        title = post.title
                        hashtagArray = post.hashtags
                        imageToEdit = post.imageName
                    }
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
                        if image != UIImage(named: "") {
                            postVm.postImage = postVm.uploadImageToServer(url: baseURL + "image")
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0)  {
                        if postVm.postImage != "" {
                            postVm.editPost(url: baseURL + "posts/", id: post.id, title: title, hashtags: hashtagArray, postImage: postVm.postImage)
                            self.isLoading = false
                            dismiss()
                        } else if imageToEdit != "" {
                            postVm.editPost(url: baseURL + "posts/", id: post.id, title: title, hashtags: hashtagArray, postImage: imageToEdit)
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
                            Text("Modifier le post")
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
        .navigationTitle("Modifie un post")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func removeRows(at offsets: IndexSet) {
        hashtagArray.remove(atOffsets: offsets)
    }
}
struct PostEditFormView_Previews: PreviewProvider {
    static var previews: some View {
        PostEditFormView(post: Post(id: 0, title: "Post title", imageName: "https://res.cloudinary.com/dvo3xgwym/image/upload/v1689863015/chs3j0klg8vqu19zsj9t.jpg", hashtags: ["beach", "sun"], userId: 1))
            .environmentObject(PostViewModel())
    }
}
