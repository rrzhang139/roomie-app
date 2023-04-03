//
//  HomeView.swift
//  Roommate App
//
//  Created by Logan Norman on 4/2/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            Text("home landing screen")
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
