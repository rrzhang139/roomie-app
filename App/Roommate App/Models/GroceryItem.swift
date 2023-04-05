//
//  GroceryItem.swift
//  Roommate App
//
//  Created by Logan Norman on 4/5/23.
//

import Foundation

class GroceryItem {
    let name: String
    let quantity: Float
    let due_date: Date
    let added_by: User
    
    init(name: String, quantity: Float, due_date: Date, added_by: User) {
        self.name = name
        self.quantity = quantity
        self.due_date = due_date
        self.added_by = added_by
    }
}
