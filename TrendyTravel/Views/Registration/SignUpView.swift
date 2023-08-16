//
//  SignUpView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 23/07/2023.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var userVm: UserViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var confirmationPassword = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var newUser = User(id: 0, firstName: "", lastName: "", description: "", profilImage: "", pseudo: "", password: "", email: "", posts: [], followers: [])
    @Environment(\.dismiss) private var dismiss
//    @Binding var isLoggedIn: Bool
    var isBtnDisabled: Bool {
        if email != "" && password != "" && confirmationPassword != "" && firstName != "" && lastName != "" {
            return false
            
        } else if password == confirmationPassword {
            return false
        }
        return true
    }
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.cyan, .mint]), startPoint: .top,
                               endPoint: .bottom)
                .ignoresSafeArea()
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .padding(.vertical, 40)
                    Form {
                        Section {
                            TextField("Prénom", text: $firstName, prompt: Text("Prénom"))
                            TextField("Nom", text: $lastName, prompt: Text("Nom"))
                            TextField("Email", text: $email, prompt: Text("Adresse email"))
                            SecureField("Mot de passe", text: $password, prompt: Text("Mot de passe"))
                            SecureField("Mot de passe confirmation", text: $confirmationPassword, prompt: Text("Confirmation du mot de passe"))
                        }
                        .foregroundColor(.cyan)
                        .listRowBackground(Color.clear)
                        .listRowSeparatorTint(Color.cyan)
                }
                .listStyle(.inset)
                .scrollIndicators(.hidden)
                .frame(height: 300)
                .cornerRadius(30)
                    NavigationLink {
                        SignUpUserDetailView(newUser: $newUser, isLoggedIn: .constant(false))
                    } label: {
                        Text("Continuer")
                            .padding()
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .background(.cyan)
                            .cornerRadius(.infinity)
                            .shadow(radius: 5)
                    }
                    .disabled(isBtnDisabled)
                    .padding(.top, 30)
                    .onDisappear {
                        newUser.firstName = firstName
                        newUser.lastName = lastName
                        newUser.email = email
                        newUser.password = password
                        print("New user first: \(newUser)")
                    }
            Spacer()
                }
                .toolbar {
                    ToolbarItem {
                        Button {
                           dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white)
                        }

                    }
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(UserViewModel())
    }
}


struct SignUpUserDetailView: View {
    @EnvironmentObject var userVm: UserViewModel
    @EnvironmentObject var viewModel: PostViewModel
    @StateObject var destinationsVm = DestinationViewModel()
    @State private var image = UIImage(named: "")
    @State private var description = ""
    @State private var pseudo = ""
    @State private var isLoading = false
    @Binding var newUser: User
    @Binding var isLoggedIn: Bool
    @Environment(\.dismiss) private var dismiss
    var isBtnDisabled: Bool {
        if description != "" && pseudo != "" {
            return false
        }
        return true
    }
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.cyan, .mint]), startPoint: .top,
                               endPoint: .bottom)
                .ignoresSafeArea()
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .padding(.vertical, 40)
                    
                    ProfileImageView(image: $image)
                        .padding(.bottom, 30)
                    Form {
                        Section {
                            TextField("Pseudo", text: $pseudo, prompt: Text("Pseudo"))
                            TextField("Description", text: $description, prompt: Text("Décris toi en une phrase"))
                        }
                        .foregroundColor(.cyan)
                        .listRowBackground(Color.clear)
                        .listRowSeparatorTint(Color.cyan)
                        .onAppear {
                            print("NewUser: \(newUser)")
                        }
                }
                .listStyle(.inset)
                .scrollIndicators(.hidden)
                .frame(height: 150)
                .cornerRadius(30)
                    Button {
                        Task {
                            if let image {
                                viewModel.image = image
                            }
                            self.isLoading = true
                            viewModel.postImage = viewModel.uploadImageToServer(url: baseURL + "image")
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            Task {
                                if viewModel.postImage != "" {
                                    isLoggedIn = try await userVm.createUser(url: baseURL + "users", firstName: newUser.firstName, lastName: newUser.lastName, description: description, profilImage: viewModel.postImage, pseudo: pseudo, password: newUser.password, email: newUser.email)
                                    self.isLoading = false
//                                    isLoggedIn = true
                                }
                            }
                        }
                    } label: {
                        Spacer()
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Inscription")
                                .padding()
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .background(.cyan)
                                .cornerRadius(.infinity)
                                .shadow(radius: 5)
                        }
                        Spacer()
                        
                    }
                    .padding(.top, 30)
                    .disabled(isBtnDisabled)
                    .navigationDestination(isPresented: $isLoading) {
                        DestinationsListView(searchDestinations: destinationsVm.destinations)
                    }

            Spacer()
                }
                .toolbar {
                    ToolbarItem {
                        Button {
                           dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white)
                        }

                    }
                }
            }
        }
     
    }
}

struct SignUpUserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpUserDetailView(newUser: .constant(User(id: 0, firstName: "", lastName: "", description: "", profilImage: "", pseudo: "", password: "", email: "", posts: [], followers: [])), isLoggedIn: .constant(false))
            .environmentObject(UserViewModel())
    }
}
