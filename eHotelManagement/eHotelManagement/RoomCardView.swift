//
//  RoomCardView.swift
//  eHotelManagement
//
//  Created by Emre on 15/11/2024.
//

import SwiftUI

// Room Card View - Custom card view for each room
struct RoomCardView: View {
    var room: Room
    var showShadow: Bool = true // Default to true for views that want the shadow

    var body: some View {
        VStack(alignment: .leading) {
            // Room Image
            AsyncImage(url: URL(string: room.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 140)
                    .clipped()
                    .cornerRadius(12)
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                // Room Name
                Text(room.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                // Room Description
                Text(room.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    // Price
                    Text("$\(room.price, specifier: "%.2f")")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Spacer()
                    
                    // Book Now Button
                    Button(action: {
                        // Booking action
                    }) {
                        Text("Book Now")
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(15)
        .if(showShadow) { view in
            view.shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal)
    }
}

