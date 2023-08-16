//
//  SignInView.swift
//  TrendyTravel
//
//  Created by Julie Collazos on 23/07/2023.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var userVm: UserViewModel
    @State private var email = ""
    @State private var password = ""
    @Binding var isLoggedIn: Bool
    @State private var isLoading = false
    @State private var showSignUpView = false
    var isBtnDisabled: Bool {
        if email != "" && password != "" {
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
                            TextField("Email", text: $email, prompt: Text("Adresse email"))
                            SecureField("Mot de passe", text: $password, prompt: Text("Mot de passe"))
                        }
                        .foregroundColor(.cyan)
                        .listRowBackground(Color.clear)
                        .listRowSeparatorTint(Color.cyan)
                    }
                    .listStyle(.inset)
                    .scrollIndicators(.hidden)
                    .listRowSeparatorTint(.cyan)
                    .frame(height: 150)
                    .cornerRadius(30)
                    
                    Button {
                        Task {
                            isLoading = true
                            isLoggedIn = try await userVm.signIn(password: password, email: email)
                        }
                    } label: {
                        if isLoading {
                            ProgressView()
                                .padding()
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .background(.cyan)
                                .cornerRadius(.infinity)
                                .shadow(radius: 5)
                        } else {
                            Text("Connexion")
                                .padding()
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .background(.cyan)
                                .cornerRadius(.infinity)
                                .shadow(radius: 5)
                        }
                        
                    }
                    .disabled(isBtnDisabled)
                    .padding(.top, 30)
                    Button {
                        showSignUpView.toggle()
                    } label: {
                        Text("Pas encore de compte ? ")
                            .padding(10)
                            .foregroundColor(.cyan)
                            .fontWeight(.bold)
                            .background(.white)
                            .cornerRadius(.infinity)
                            .shadow(radius: 5)
                    }
                    .padding(50)
                    .fullScreenCover(isPresented: $showSignUpView, content: {
                        SignUpView()
                    })
//                    .sheet(isPresented: $showSignUpView) {
//                        SignUpView()
//                    }

                  
                    Spacer()
                }
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(isLoggedIn: .constant(false))
            .environmentObject(UserViewModel())
    }
}
