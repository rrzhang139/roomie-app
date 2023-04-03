//
//  CreateRoommateGroup.swift
//  Roommate App
//
//  Created by Logan Norman on 4/2/23.
//

import SwiftUI

struct CreateRoommateGroup: View {
    @State private var roomName = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Create a group")
                    .font(.system(size: 30, weight: .semibold))
                
                VStack {
                    TextField("Enter a room name", text: $roomName)
                        .font(.title3)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .padding()
                    
                    NavigationLink(destination: HomeView()) {
                        HStack {
                            Text("Create")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .navigationBarBackButtonHidden(true)
                    .shadow(color: .gray, radius: 5, x: 0, y: 2)
                }
            }
        }
    }
}

struct CreateRoommateGroup_Previews: PreviewProvider {
    static var previews: some View {
        CreateRoommateGroup()
    }
}
