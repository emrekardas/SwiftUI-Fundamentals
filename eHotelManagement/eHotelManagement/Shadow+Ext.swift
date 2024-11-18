//
//  Shadow+Exy.swift
//  eHotelManagement
//
//  Created by Emre on 15/11/2024.
//

import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
