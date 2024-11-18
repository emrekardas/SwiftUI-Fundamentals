//
//  HomePageRoomCardView.swift
//  eHotelManagement
//
//  Created by Emre on 15/11/2024.
//

import SwiftUI

struct HomePageRoomCardView: View {
    var room: Room

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Room Image
            AsyncImage(url: URL(string: room.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 260, height: 120) // Adjusted dimensions for a larger image
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ProgressView()
                    .frame(width: 260, height: 120)
            }

            // Room Details
            VStack(alignment: .leading, spacing: 4) {
                Text(room.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(room.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1) // Truncate description for a clean look
            }
            .padding(.horizontal, 8)
            
            // Footer with Price and Book Button
            HStack {
                Text("$\(room.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                Spacer()
                
                Button(action: {
                    // Booking action here
                }) {
                    Text("Book Now")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color.white) // Set background to white
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 4)
        .frame(width: 260) // Adjust width to ensure the card fits nicely
    }
}

// Rounded corner extension for specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 0.0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

