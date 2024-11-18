//
//  ContentView.swift
//  eHotelManagement
//
//  Created by Emre on 13/11/2024.
//

//
//  MainPageTabView.swift
//  eHotelManagement
//
//  Created by Emre on 13/11/2024.
//

import SwiftUI

struct MainPageTabView: View {
    @State private var selectedTab = 0 // Tab selection index

    var body: some View {
        TabView(selection: $selectedTab) {
            HomePageView(selectedTab: $selectedTab) // Pass selectedTab as a Binding
                .tabItem {
                    Image(systemName: "house")
                }
                .tag(0)
            
            RoomsPageView()
                .tabItem {
                    Image(systemName: "bed.double.fill")
                }
                .tag(1)
            
            MyRoomPageView()
                .tabItem {
                    Image(systemName: "calendar")
                }
                .tag(2)
            
            AccountPageView()
                .tabItem {
                    Image(systemName: "person.fill")
                }
                .tag(3)
        }
    }
}

#Preview {
    MainPageTabView()
}
