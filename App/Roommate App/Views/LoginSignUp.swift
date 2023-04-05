//
//  SwiftUIView.swift
//  Roommate App
//
//  Created by Logan Norman on 4/1/23.
//

import SwiftUI

struct LoginSignUp: View {
    @State private var showSignupModal = false
    @State private var showLoginModal = false
    
    var body: some View {
        VStack {
            Text("Roomies")
                .font(.system(size: 36, weight: .semibold))
            
            VStack {
                Button(action: {
                    self.showSignupModal = true
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .tint(.black)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showSignupModal) {
                    SignUpModal()
                }
                
                Button(action: {
                    self.showLoginModal = true
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $showLoginModal) {
                    LoginModal()
                        .navigationBarBackButtonHidden(true)
                }
            }
            .padding()
        }
    }
}


struct SignUpModal: View {
    @State private var firstname = ""
    @State private var lastname = ""
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    @State private var showNewUserLanding = false
    
    var body: some View {
        VStack {
            Text("Join Roomies")
                .font(.title)
                .fontWeight(.bold)
            
            HStack {
                TextField("First Name", text: $firstname)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .regular))
                    .accentColor(.black)
                    .autocapitalization(.none)
                
                TextField("Last Name", text: $lastname)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .regular))
                    .accentColor(.black)
                    .autocapitalization(.none)
            }
            
            TextField("Enter your email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.black)
                .font(.system(size: 18, weight: .regular))
                .accentColor(.black)
                .autocapitalization(.none)
            
            TextField("Enter a username", text: $username)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.black)
                .font(.system(size: 18, weight: .regular))
                .accentColor(.black)
                .autocapitalization(.none)
            
            SecureField("Enter a password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .foregroundColor(.black)
                .font(.system(size: 18, weight: .regular))
                .accentColor(.black)
                .autocapitalization(.none)
            
            Button(action: {
                withAnimation {
                    // Navigate to the new user landing page
                    let body = [
                        "username" : username,
                        "password" : password,
                        "first_name" : firstname,
                        "last_name" : lastname,
                        "email" : email
                    ]
                    
                    APIClient.signup(body: body) { success, error in
                        if success {
                            print("Signup successful")
                            self.showNewUserLanding = true
                        } else {
                            print("Signup failed")
                        }
                    }
                }
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background([username, password, email, firstname, lastname].allSatisfy { !$0.isEmpty }
                                ? Color.blue : Color.gray)
                    .cornerRadius(10)
            }
            .disabled([username, password, email, firstname, lastname].allSatisfy { $0.isEmpty })
            .fullScreenCover(isPresented: $showNewUserLanding) {
                NewUserLanding()
                    .transition(.move(edge: .leading))
            }
            .padding()
        }
        .padding()
    }
}

struct LoginModal: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var username = ""
    @State private var password = ""
    @State private var showNewUserLanding = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome Back")
                    .font(.title)
                    .fontWeight(.bold)
                
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .regular))
                    .accentColor(.black)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .regular))
                    .accentColor(.black)
                    .autocapitalization(.none)
                
                Button(action: {
                    withAnimation {
                        // navigate to the user landing page
                        let body = [
                            "email" : username,
                            "password" : password,
                        ]
                        
                        APIClient.login(body: body) { success, error in
                            if success {
                                print("Signup successful")
                                self.showNewUserLanding = true
                            } else {
                                print("Signup failed")
                            }
                        }
                    }
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $showNewUserLanding) {
                    NewUserLanding()
                        .transition(.move(edge: .leading))
                }
                .padding()
            }
            .padding()
        }
    }
}


struct LoginSignUp_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignUp()
    }
}
