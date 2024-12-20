//
//  ContentView.swift
//  Appetizers
//
//  Created by Emre on 11/11/2024.
//

import SwiftUI

struct AppetizerTabView: View {
    
    var body: some View {
        
        TabView{
            AppetizerListView()
                .tabItem{
                    Image(systemName: "house")
                    Text("Home")
                }
            AccountView()
                .tabItem{
                    Image(systemName: "person")
                    Text("Account")
                }
            OrderView()
                .tabItem{
                    Image(systemName: "bag")
                    Text("Order")
                }
        }
        .accentColor(Color("brandPrimary"))
    }
}

#Preview {
    AppetizerTabView()
}
