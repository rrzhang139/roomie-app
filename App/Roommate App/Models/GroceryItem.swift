//
//  GroceryItem.swift
//  Roommate App
//
//  Created by Logan Norman on 4/5/23.
//

import Foundation

enum ItemStatus {
    case Complete
    case InProgress
}

class GroceryItem : Identifiable {
    let name: String
    let quantity: Float
    let due_date: Date
    let added_by: User
    let status: ItemStatus
    
    init(name: String, quantity: Float, due_date: Date, added_by: User, status: ItemStatus) {
        self.name = name
        self.quantity = quantity
        self.due_date = due_date
        self.added_by = added_by
        self.status = status
    }
}
