//
//  SplashScreenView.swift
//  eHotelManagement
//
//  Created by Emre on 13/11/2024.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 1.0

    var body: some View {
        if isActive {
            MainPageTabView()  // Ana görünüm
        } else {
            Image("regnum-carya-splash-screen")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(opacity)
                .frame(height:UIScreen.main.bounds.height)
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

#Preview {
    SplashScreenView()
}

