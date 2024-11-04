//
//  ContentView.swift
//  weatherApp
//
//  Created by Emre KARDAS on 11/4/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isNightMode: Bool = false
    
    var body: some View {
        ZStack{
            ContainerRelativeShape()
                .fill(isNightMode ? Color.black.gradient : Color.blue.gradient)
                .ignoresSafeArea()// Full Screen Size
            
            VStack{
                CityTextView(cityName: "London, UK")
                
                MainWeatherView(imageName: isNightMode ? "moon.zzz.fill" : "cloud.sun.fill",
                                temperature: 26
                )
                
                HStack(spacing: 20){
                    WeatherDayView(dayOfWeek: "TUE",
                                   imageName: "cloud.sun.fill",
                                   temprature: 15)
                    
                    WeatherDayView(dayOfWeek: "WED",
                                   imageName: "wind",
                                   temprature: 15)
                    
                    WeatherDayView(dayOfWeek: "THUR",
                                   imageName: "sunset.fill",
                                   temprature: 15)
                    
                    WeatherDayView(dayOfWeek: "FRI",
                                   imageName: "sun.rain.fill",
                                   temprature: 15)
                    
                    WeatherDayView(dayOfWeek: "SAT",
                                   imageName: "sun.horizon.fill",
                                   temprature: 15)
                }
                
                Spacer()
                
                Button {
                    isNightMode.toggle()
                }label: {
                    WeatherAppButton(buttonText: "Change Day Time")
                }
                Spacer()
            }
        }
    }
}

struct WeatherDayView: View {
    
    var dayOfWeek: String
    var imageName: String
    var temprature: Int
    
    var body: some View {
        VStack{
            Text(dayOfWeek)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            Image(systemName: imageName)
//                .symbolRenderingMode(.hierarchical)
//                .resizable()
//                .foregroundColor(•pink)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            Text("\(temprature)°C")
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
        }
    }
}

struct CityTextView: View {
    
    var cityName : String
    
    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding()
    }
}

struct MainWeatherView: View {
    
    var imageName : String
    var temperature : Int
    
    var body: some View {
        VStack(spacing: 8){
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            Text("\(temperature)°C")
                .font(.system(size: 64, weight: .medium, design: .default))
                .foregroundColor(.white)
        }
        .padding(.bottom,40)
    }
}

struct WeatherAppButton: View {
    
    var buttonText : String
    
    var body: some View {
        Text(buttonText)
            .frame(width: 280 , height: 50)
            .background(Color.white)
            .foregroundColor(Color.blue)
            .font(.system(size: 20, weight: .medium, design: .default))
            .cornerRadius(10)
    }
}



#Preview {
    ContentView()
}
