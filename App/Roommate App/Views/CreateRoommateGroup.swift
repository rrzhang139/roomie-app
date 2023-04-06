//
//  CreateRoommateGroup.swift
//  Roommate App
//
//  Created by Logan Norman on 4/2/23.
//

import SwiftUI

struct CreateRoommateGroup: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var roomName: String
    @Binding var isNavigating: Bool
    
    var body: some View {
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
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                    isNavigating = true
                } label: {
                    Text("Create")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(!roomName.isEmpty ? Color.blue : Color.gray)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                }
                .disabled(roomName.isEmpty)
            }
        }
    }
}

struct CreateRoommateGroup_Previews: PreviewProvider {
    static var previews: some View {
        CreateRoommateGroup(roomName: .constant("cheesey group name"), isNavigating: .constant(false))
    }
}
