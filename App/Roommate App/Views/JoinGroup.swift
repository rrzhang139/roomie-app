//
//  JoinGroup.swift
//  Roommate App
//
//  Created by Logan Norman on 4/2/23.
//

import SwiftUI

struct JoinGroup: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    @Binding var isNavigating: Bool
    
    var body: some View {
        VStack {
            Text("Join a Group")
                .font(.system(size: 30, weight: .semibold))
            
            VStack {
                TextField("Enter a roommate's email", text: $email)
                    .font(.title3)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding()
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                    isNavigating = true
                } label: {
                    Text("Join")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(!email.isEmpty ? Color.blue : Color.gray)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                }
                .disabled(email.isEmpty)
            }
        }
    }
}

struct JoinGroup_Previews: PreviewProvider {
    static var previews: some View {
        JoinGroup(isNavigating: .constant(false))
    }
}
