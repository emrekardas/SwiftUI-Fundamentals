//
//  Rooms.swift
//  eHotelManagement
//
//  Created by Emre on 13/11/2024.
//

import SwiftUI

struct Room: Identifiable {
    var id = UUID()
    var name: String
    var price: Double
    var description: String
    var imageUrl: String
}

// Sample data with Lorem Picsum URLs
let sampleRooms = [
    Room(name: "Deluxe Suite", price: 250.0, description: "Spacious suite with ocean view.", imageUrl: "https://picsum.photos/200/300"),
    Room(name: "Standard Room", price: 100.0, description: "Comfortable room with basic amenities.", imageUrl: "https://picsum.photos/200/301"),
    Room(name: "Family Room", price: 180.0, description: "Perfect for families with a cozy setup.", imageUrl: "https://picsum.photos/200/302"),
    Room(name: "Presidential Suite", price: 500.0, description: "Luxurious suite with premium services.", imageUrl: "https://picsum.photos/200/303"),
]
