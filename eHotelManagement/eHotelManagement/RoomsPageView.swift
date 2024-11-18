//
//  RoomsPageView.swift
//  eHotelManagement
//
//  Created by Emre on 13/11/2024.
//

//
//  RoomsPageView.swift
//  eHotelManagement
//
//  Created by Emre on 13/11/2024.
//

import SwiftUI

struct RoomsPageView: View {
    var rooms: [Room] = sampleRooms
    @State private var showFilterPopup = false  // Filter pop-up control

    var body: some View {
        VStack(spacing: 10) {
            // Logo and Filter Button Side by Side
            HStack {
                Logo()
                Spacer()
                
                Button(action: {
                    showFilterPopup = true  // Show the filter pop-up
                }) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .padding(.trailing)
            }
            .padding(.top, 10) // Top padding
            .padding(.horizontal)

            // Room List
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(rooms) { room in
                        RoomCardView(room: room, showShadow: true)
                            .padding(.horizontal)
                            .padding(.bottom, 8) // Bottom padding for each card
                    }
                }
            }
        }
        .sheet(isPresented: $showFilterPopup) {
            FilterDatePickerPopupView()
        }
        .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)) // Light gray background for entire view
    }
}


// Preview
#Preview {
    RoomsPageView()
}
