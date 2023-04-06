//
//  User.swift
//  Roommate App
//
//  Created by Logan Norman on 4/5/23.
//

import Foundation

class User : ObservableObject {
    @Published var token: UserToken
    @Published var username: String?
    @Published var email: String?
    @Published var firstname: String?
    @Published var lastname: String?
    @Published var group: RoommateGroup?
    
    init(token:UserToken) {
        self.token = token
    }
}
