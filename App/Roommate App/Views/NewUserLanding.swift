//
//  NewUserLanding.swift
//  Roommate App
//
//  Created by Logan Norman on 4/1/23.
//

import SwiftUI

struct NewUserLanding: View {
    @State private var createGroupActive = false
    @State private var joinGroupActive = false
    @State private var isNavigating = false
    @State private var roomName = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Roomies")
                    .font(.system(size: 36, weight: .semibold))
                
                // Button to create a new roommate group
                NavigationLink(destination: MainView(roomName: $roomName).navigationBarBackButtonHidden(true), isActive: $isNavigating) {
                    Button {
                        self.createGroupActive = true
                    } label: {
                        HStack {
                            Text("Create a new roommate group")
                                .padding()
                            
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                                .frame(width: 50, height: 50)
                                .background(Color.blue)
                                .cornerRadius(22)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(22)
                    .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                    .padding(.vertical)
                    .sheet(isPresented: $createGroupActive, onDismiss: {
                        print("spotemgotem")
                    }) {
                        CreateRoommateGroup(roomName: $roomName, isNavigating: $isNavigating)
                    }
                }
                
                // Button to join a new roommate group
                NavigationLink(destination: MainView(roomName: $roomName).navigationBarBackButtonHidden(true), isActive: $isNavigating) {
                    Button {
                        self.joinGroupActive = true
                    } label: {
                        Text("Join an existing group")
                            .padding()
                        Image(systemName: "person.3.sequence.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .frame(width: 50, height: 50)
                            .background(Color.blue)
                            .cornerRadius(22)
                    }
                    .background(Color.white)
                    .cornerRadius(22)
                    .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                    .padding(.vertical)
                    .sheet(isPresented: $joinGroupActive) {
                        JoinGroup(isNavigating: $isNavigating)
                    }
                }
            }
        }
        .padding()
    }
    
    struct NewUserLanding_Previews: PreviewProvider {
        static var previews: some View {
            NewUserLanding()
        }
    }
}

