//
//  AppetizerListViewModel.swift
//  Appetizers
//
//  Created by Emre on 11/11/2024.
//

import SwiftUI

final class AppetizerListViewModel: ObservableObject {
    @Published var appetizers: [Appetizer] = []
    @Published var alertItem: AlertItem?
    @Published var isLoading = false
    
    func getAppetizers() {
        isLoading = true
        
        // Cache üzerinden verileri kontrol edin
        if let cachedAppetizers = NetworkManager.shared.getCachedAppetizers() {
            self.appetizers = cachedAppetizers
            isLoading = false
            return
        }
        
        NetworkManager.shared.getAppetizers { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let appetizers):
                    self.appetizers = appetizers
                    NetworkManager.shared.cacheAppetizers(appetizers) // Verileri cache'e kaydet
                    
                case .failure(let error):
                    switch error {
                    case .invalidData:
                        self.alertItem = AlertContext.invalidData
                        
                    case .invalidResponse:
                        self.alertItem = AlertContext.invalidResponse
                        
                    case .invalidURL:
                        self.alertItem = AlertContext.invalidURL
                        
                    case .unableToComplete:
                        self.alertItem = AlertContext.unableToComplete
                    }
                }
            }
        }
    }
}
