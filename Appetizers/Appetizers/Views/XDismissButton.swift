//
//  XDismissButton.swift
//  Appetizers
//
//  Created by Emre on 11/11/2024.
//

import SwiftUI

struct XDismissButton: View {
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .opacity(0.6)
            Image(systemName: "xmark")
                .imageScale(.small)
                .foregroundColor(.black)
                .padding()
        }
    }
}

#Preview {
    XDismissButton()
}
