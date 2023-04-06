//
//  HomeView.swift
//  Roommate App
//
//  Created by Logan Norman on 4/2/23.
//

import SwiftUI

struct MainView: View {
    @Binding var roomName: String
    @State private var selection = 0
    
    init(roomName: Binding<String>) {
        _roomName = roomName
    }
    
    var body: some View {
        TabView(selection: $selection) {
            // Home view
            Home()
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("Home")
                }
                .tag(0)
            
            // Tasks view
            Tasks()
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Tasks")
                }
                .tag(1)
            
            // Shopping list view
            GroceryList()
                .tabItem {
                    Image(systemName: "3.circle")
                    Text("Groceries")
                }
                .tag(2)
            
            // Bills view
            Bills()
                .tabItem {
                    Image(systemName: "4.circle")
                    Text("Bills")
                }
                .tag(3)
            
            // Schedule view
            Schedule()
                .tabItem {
                    Image(systemName: "5.circle")
                    Text("Schedule")
                }
                .tag(4)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(roomName: .constant("YESSUH"))
    }
}
