//
//  fetchProductInfo.swift
//  Barcode-Scanner
//
//  Created by Emre KARDAS on 11/5/24.
//

import Foundation

struct ProductResponse: Codable {
    let products: [Product]
}

struct Product: Codable {
    let barcode_number: String?
    let product_name: String?
    let description: String?
    let category: String?
    let brand: String?
    let images: [String]?
}


func fetchProductInfo(for barcode: String, apiKey: String, completion: @escaping (Product?) -> Void) {
    let urlString = "https://api.barcodelookup.com/v3/products?barcode=\(barcode)&formatted=y&key=\(apiKey)"
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print("API isteği başarısız: \(error?.localizedDescription ?? "Bilinmeyen hata")")
            completion(nil)
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let productResponse = try decoder.decode(ProductResponse.self, from: data)
            completion(productResponse.products.first)
        } catch {
            print("JSON çözümleme hatası: \(error.localizedDescription)")
            completion(nil)
        }
    }.resume()
}
