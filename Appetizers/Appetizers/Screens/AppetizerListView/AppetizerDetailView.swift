//
//  AppetizerDetailView.swift
//  Appetizers
//
//  Created by Emre on 11/11/2024.
//

import SwiftUI

struct AppetizerDetailView: View {
    
    let appetizer: Appetizer
    @Binding var isShowingDetail: Bool
    
    var body: some View {
        
        VStack{
            AppetizerRemoteImage(urlString: appetizer.imageURL)
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 225)
            
            VStack{
                Text(appetizer.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                Text(appetizer.description)
                    .multilineTextAlignment(.center)
                    .font(.body)
                    .padding()
                
                HStack(spacing: 40){
                    NutritionInfo(title: "Calories", value: appetizer.calories)
                    NutritionInfo(title: "Protein", value: appetizer.protein)
                    NutritionInfo(title: "Carbs", value: appetizer.carbs)
                }
            }
            
            Spacer()
            
            Button{
                print("Order button was tapped")
            } label: {
                APButton(title: "$\(appetizer.price, specifier: "%.2f") - Add to Order")
            }
            .padding(.bottom, 30)
            
        }
        .frame(maxWidth: 300, maxHeight: 525)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 40)
        .overlay(Button{
            isShowingDetail = false
        } label: {
            XDismissButton()
        }, alignment: .topTrailing)
    }
}

#Preview {
    AppetizerDetailView(appetizer: MockData.sampleAppetizer, isShowingDetail: .constant(true))
}

struct NutritionInfo : View{
    let title: String
    let value: Int
    
    var body: some View{
        VStack(spacing: 5){
            Text(title)
                .bold()
                .font(.caption)
            
            Text("\(value)")
                .foregroundColor(.secondary)
                .fontWeight(.semibold)
                .italic()
        }
    }
}