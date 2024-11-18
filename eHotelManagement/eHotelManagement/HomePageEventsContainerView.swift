//
//  HomePageEventsContainerView.swift
//  eHotelManagement
//
//  Created by Emre on 13/11/2024.
//

import SwiftUI

struct HomePageEventsContainerView: View {
    var body: some View {
        HStack(spacing: 10) {
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 250)
                    .overlay(
                        VStack {
                            Image(systemName: "calendar")  // Buraya görsel gelecek
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .padding(.bottom, 5)
                            
                            Text("Events")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                    )
            }
            Spacer()
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 250)
                    .overlay(
                        VStack {
                            Image(systemName: "sportscourt")  // Buraya görsel gelecek
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .padding(.bottom, 5)
                            
                            Text("Sports")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                    )
            }
            Spacer()
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 250)
                    .overlay(
                        VStack {
                            Image(systemName: "leaf.fill")  // Buraya görsel gelecek
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .padding(.bottom, 5)
                            
                            Text("Spa")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                    )
            }
        }
        .padding()
    }
}
#Preview {
    HomePageEventsContainerView()
}
