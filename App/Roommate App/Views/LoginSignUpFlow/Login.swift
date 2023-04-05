//
//  Login.swift
//  Roommate App
//
//  Created by Logan Norman on 4/4/23.
//

import SwiftUI

struct Login: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    @State private var password = ""
    
    @State private var isNavigating = false
    @State private var failed = false
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            Text("Welcome Back")
                .font(.title)
                .fontWeight(.bold)
            
            TextField("email", text: $email)
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
            
            if failed {
                Text("Invalid email/password")
                    .foregroundColor(.red)
            }
            
            // TODO: If the user isn't part of a group, show NewUserLanding, else HomeView
            NavigationLink(destination: NewUserLanding().navigationBarBackButtonHidden(true), isActive: $isNavigating) {
                Button (action: {
                    let body = [
                        "email" : email,
                        "password" : password,
                    ]
                    
                    APIClient.login(body: body) { success, error in
                        if success {
                            print("Login successful")
                            self.isNavigating = true
                        } else {
                            self.failed = true
                            print("Login failed")
                        }
                    }
                }) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background([email, password].allSatisfy { !$0.isEmpty }
                                        ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
