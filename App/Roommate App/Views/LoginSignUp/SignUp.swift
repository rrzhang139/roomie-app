//
//  SignUp.swift
//  Roommate App
//
//  Created by Logan Norman on 4/4/23.
//

import SwiftUI

struct SignUp: View {
    // Info from the user
    @State private var firstname = ""
    @State private var lastname = ""
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    
    // Boolean state values
    @State private var isNavigating = false
    @State private var isLoading = false
    @State private var failed = false
    
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
            
            if failed {
                Text("Error: One of those fields are invalid, good luck lol")
                    .foregroundColor(.red)
            }
            
            NavigationLink(destination: NewUserLanding().navigationBarBackButtonHidden(true), isActive: $isNavigating) {
                Button (action: {
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
                            self.isNavigating = true
                        } else {
                            self.failed = true
                            print("Signup failed")
                        }
                    }
                }) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background([username, password, email, firstname, lastname].allSatisfy { !$0.isEmpty }
                                        ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
