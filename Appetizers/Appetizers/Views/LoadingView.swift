//
//  LoadingView.swift
//  Appetizers
//
//  Created by Emre on 11/11/2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.white // Arka plan rengini yarı saydam olarak ayarlayın
                .ignoresSafeArea()   // Ekranın tamamını kaplamasını sağlar
            
            ProgressView("")
                .progressViewStyle(CircularProgressViewStyle(tint: Color("brandPrimary")))
                .foregroundColor(.secondary)
                .scaleEffect(1.5)
                .padding()
        }
    }
}

#Preview {
    LoadingView()
}
