//
//  FilterDatePickerPopupView.swift
//  eHotelManagement
//
//  Created by Emre on 13/11/2024.
//

import SwiftUI

struct FilterDatePickerPopupView: View {
    @State private var selectedDate = Date()  // Date Picker için tarih seçimi
    @State private var selectedFilter = "All Rooms"  // Filtre seçenekleri
    @State private var selectedSort = "Price: Low to High"  // Sıralama seçenekleri
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Date Picker
            VStack(alignment: .leading) {
                Text("Select Date")
                    .font(.headline)
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            // Filter Options
            VStack(alignment: .leading) {
                Text("Filter by")
                    .font(.headline)
                Picker("Filter", selection: $selectedFilter) {
                    Text("All Rooms").tag("All Rooms")
                    Text("Family Rooms").tag("Family Rooms")
                    Text("Luxury Rooms").tag("Luxury Rooms")
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            // Sort Options
            VStack(alignment: .leading) {
                Text("Sort by")
                    .font(.headline)
                Picker("Sort", selection: $selectedSort) {
                    Text("Price: Low to High").tag("Price: Low to High")
                    Text("Price: High to Low").tag("Price: High to Low")
                    Text("Most Popular").tag("Most Popular")
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            // Apply Button
            Button(action: {
                // Filter uygulama işlemi burada yapılabilir
                // Pop-up kapatma işlemi üst parent view'de yapılabilir
            }) {
                Text("Apply Filters")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    FilterDatePickerPopupView()
}
