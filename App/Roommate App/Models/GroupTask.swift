//
//  GroupTask.swift
//  Roommate App
//
//  Created by Logan Norman on 4/5/23.
//

import Foundation

enum TaskStatus {
    case Complete
    case InProgress
}

class GroupTask {
    let name: String
    let assignees: [User]
    let description: String
    let due_date: Date
    let status: TaskStatus = .InProgress
    
    init(name: String, assignees: [User], description: String, due_date: Date) {
        self.name = name
        self.assignees = assignees
        self.description = description
        self.due_date = due_date
    }
}
