//
//  HomePageRoomsContainerView.swift
//  eHotelManagement
//
//  Created by Emre on 13/11/2024.
//

import SwiftUI

struct HomePageRoomsContainerView: View {
    @Binding var selectedTab: Int // Binding to change the tab
    var rooms: [Room] = sampleRooms

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title and View All Button
            HStack {
                Text("Rooms")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Spacer()

                Button(action: {
                    selectedTab = 1 // Switch to RoomsPageView in the TabView
                }) {
                    Text("View All")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)

            // Scrollable Room Cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(rooms) { room in
                        HomePageRoomCardView(room: room)
                    }
                }
                .padding([.horizontal, .bottom], 8)
            }
        }
        .padding()
    }
}

#Preview {
    HomePageRoomsContainerView(selectedTab: .constant(0)) // Use a constant for preview
}
