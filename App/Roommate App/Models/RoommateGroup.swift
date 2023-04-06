//
//  RoommateGroup.swift
//  Roommate App
//
//  Created by Logan Norman on 4/5/23.
//

import Foundation

class RoommateGroup {
    let name: String
    let roommates: [User]
    let bills: [Bill]
    let tasks: [GroupTask]
    let groceries: [GroceryItem]
    
    init(name: String, roommates: [User], bills: [Bill]? = nil, tasks: [GroupTask]? = nil, groceries: [GroceryItem]? = nil) {
        self.name = name
        self.roommates = roommates
        self.bills = bills ?? []
        self.tasks = tasks ?? []
        self.groceries = groceries ?? []
    }
}
