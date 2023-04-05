//
//  Login.swift
//  Roommate App
//
//  Created by Logan Norman on 4/4/23.
//

import SwiftUI

struct Login: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var username = ""
    @State private var password = ""
    @State private var isNavigating = false
    @State private var failed = false
    
    var body: some View {
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
            
            if failed {
                Text("Invalid username/password")
                    .foregroundColor(.red)
            }
            
            NavigationLink(destination: NewUserLanding().navigationBarBackButtonHidden(true), isActive: $isNavigating) {
                Text("Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background((!username.isEmpty && !password.isEmpty) ? Color.blue : Color.gray)
                    .cornerRadius(10)
                    .onTapGesture {
                        let body = [
                            "email" : username,
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
