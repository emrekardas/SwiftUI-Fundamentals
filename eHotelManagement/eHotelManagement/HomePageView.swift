//
//  HomePageView.swift
//  eHotelManagement
//
//  Created by Emre on 13/11/2024.
//

//
//  HomePageView.swift
//  eHotelManagement
//
//  Created by Emre on 13/11/2024.
//

import SwiftUI

struct HomePageView: View {
    @Binding var selectedTab: Int // Binding to change tab selection

    var body: some View {
        VStack {
            Logo()
            ScrollView {
                WeatherView()
                HomePageRoomsContainerView(selectedTab: $selectedTab) // Pass selectedTab to HomePageRoomsContainerView
                HomePageEventsContainerView()
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedTab = 0
    return HomePageView(selectedTab: $selectedTab)
}
