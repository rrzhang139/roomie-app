//
//  SignUp.swift
//  Roommate App
//
//  Created by Logan Norman on 4/4/23.
//

import SwiftUI

struct SignUp: View {
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

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
