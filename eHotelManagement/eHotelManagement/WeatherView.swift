//
//  WeatherView.swift
//  eHotelManagement
//
//  Created by Emre on 13/11/2024.
//

//
//  WeatherView.swift
//  eHotelManagement
//
//  Created by Emre on 13/11/2024.
//

import SwiftUI
import WeatherKit
import CoreLocation

let kadriyeLocation = CLLocation(latitude: 36.8563, longitude: 30.9853)

struct WeatherView: View {
    @State private var weather: Weather?
    private let weatherService = WeatherService()

    var body: some View {
        VStack(spacing: 0) {  // VStack içindeki spacing'i sıfıra ayarladık
            if let weather = weather {
                // Hava durumu kartı
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.4)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .cornerRadius(15)
                    .shadow(radius: 5)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        // Konum ve sıcaklık
                        HStack {
                            Text("Regnum Carya")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: symbolName(for: weather.currentWeather.condition))
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        
                        Text("\(Int(weather.currentWeather.temperature.value))°")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(weather.currentWeather.condition.description)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Spacer()
                        
                        // Günlük tahmin, kompakt boyut
                        HStack(spacing: 15) {
                            ForEach(weather.dailyForecast.prefix(5), id: \.date) { forecast in
                                VStack {
                                    Text(forecast.date, format: .dateTime.day())
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                    Image(systemName: symbolName(for: forecast.condition))
                                        .font(.caption)
                                        .foregroundColor(.white)
                                    
                                    Text("\(Int(forecast.highTemperature.value))°/\(Int(forecast.lowTemperature.value))°")
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                        }
                        .padding(.top, 5)
                    }
                    .padding()
                }
                .padding()
            } else {
                // Yüklenme durumu
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 80)
                    .overlay(
                        Text("Loading weather...")
                            .font(.headline)
                            .foregroundColor(.black)
                    )
                    .padding(.horizontal)
            }
        }
        .onAppear {
            Task {
                await fetchWeather()
            }
        }
    }

    // Hava durumu verilerini çeken fonksiyon
    func fetchWeather() async {
        do {
            weather = try await weatherService.weather(for: kadriyeLocation)
        } catch {
            print("Weather fetching failed: \(error)")
        }
    }
    
    // Hava durumu simgesini belirleyen fonksiyon
    func symbolName(for condition: WeatherCondition) -> String {
        switch condition {
        case .clear, .mostlyClear:
            return "sun.max.fill"
        case .partlyCloudy:
            return "cloud.sun.fill"
        case .cloudy:
            return "cloud.fill"
        case .rain:
            return "cloud.rain.fill"
        case .snow:
            return "snow"
        case .windy:
            return "wind"
        default:
            return "cloud.fill"
        }
    }
}

#Preview {
    WeatherView()
}
