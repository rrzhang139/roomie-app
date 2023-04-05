//
//  Bill.swift
//  Roommate App
//
//  Created by Logan Norman on 4/5/23.
//

import Foundation

enum Status {
    case Paid
    case UnPaid
}

class Bill {
    let submitter: User
    let amount: Float
    let date: Date
    let status: Status
    
    init(submitter: User, amount: Float, date: Date, status: Status) {
        self.submitter = submitter
        self.amount = amount
        self.date = date
        self.status = status
    }
}
