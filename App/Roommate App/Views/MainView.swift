//
//  HomeView.swift
//  Roommate App
//
//  Created by Logan Norman on 4/2/23.
//

import SwiftUI

struct HomeView: View {
    @Binding var roomName: String
    @State private var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            // Home view
            Text("Home view")
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("First")
                }
                .tag(0)
            
            // Tasks view
            Text("Tasks view")
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Second")
                }
                .tag(1)
            
            // Shopping list view
            Text("Shopping List View")
                .tabItem {
                    Image(systemName: "3.circle")
                    Text("Third")
                }
                .tag(2)
            
            // Bills view
            Text("Bills View")
                .tabItem {
                    Image(systemName: "4.circle")
                    Text("Third")
                }
                .tag(3)
            
            // Schedule view
            Text("Schedule View")
                .tabItem {
                    Image(systemName: "5.circle")
                    Text("Third")
                }
                .tag(4)
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    @Binding var roomName: String
    static var previews: some View {
        HomeView(roomName: .constant("YESSUH"))
    }
}
