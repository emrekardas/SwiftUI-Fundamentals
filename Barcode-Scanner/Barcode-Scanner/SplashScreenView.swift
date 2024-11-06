//
//  SplashScreenView.swift
//  Barcode-Scanner
//
//  Created by Emre KARDAS on 11/6/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 1.0

    var body: some View {
        if isActive {
            BarcodeScannerView()  // Ana görünüm
        } else {
            VStack {
                Image(systemName: "barcode.viewfinder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text("Barcode Scanner")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5)) {
                    self.opacity = 0.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isActive = true
                }
            }
        }
    }
}
