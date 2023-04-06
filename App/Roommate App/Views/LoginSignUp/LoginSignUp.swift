//
//  NewLoginSignUp.swift
//  Roommate App
//
//  Created by Logan Norman on 4/4/23.
//

import SwiftUI

struct LoginSignUp: View {
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Roomies")
                    .font(.system(size: 36, weight: .semibold))
                
                VStack {
                    // Signup Button
                    NavigationLink(destination: SignUp()) {
                        Text("Sign Up")
                            .font(.headline)
                            .tint(.black)
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(10)
                    }
                    
                    // Login button
                    NavigationLink(destination: Login()) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
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
}
