//
//  fetchProductInfo.swift
//  Barcode-Scanner
//
//  Created by Emre KARDAS on 11/5/24.
//

import Foundation

struct OpenFoodFactsResponse: Codable {
    let code: String?
    var product: Product?
    let status: Int?
}

struct Product: Codable {
    let product_name: String?
    let image_url: String?
    let ingredients_text: String?
    let categories: String?
    let brands: String?
    let quantity: String?
    let nutriments: Nutriments?
    let stores: StoresType? // stores alanını güncelledik
    let ingredients_analysis_tags: [String?]
    var isVegan: Bool?
    var isVegetarian: Bool?
    
    enum StoresType: Codable {
        case single(String)
        case list([String])

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let singleStore = try? container.decode(String.self) {
                self = .single(singleStore)
            } else if let storeList = try? container.decode([String].self) {
                self = .list(storeList)
            } else {
                throw DecodingError.typeMismatch(StoresType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected String or [String]"))
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .single(let store):
                try container.encode(store)
            case .list(let stores):
                try container.encode(stores)
            }
        }
    }
}

struct Nutriments: Codable {
    let energy: Double? // Enerji (kcal)
    let fat: Double? // Yağ (g)
    let saturated_fat: Double? // Doymuş Yağ (g)
    let sugars: Double? // Şeker (g)
    let salt: Double? // Tuz (g)
}



func fetchProductInfo(for code: String, completion: @escaping (Product?) -> Void) {
    // API URL'sini ayarlayın
    guard let url = URL(string: "https://api.openfoodfacts.org/api/v0/product/\(code).json") else {
        print("Geçersiz URL")
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
            var productResponse = try decoder.decode(OpenFoodFactsResponse.self, from: data)

            // Vegan ve vejetaryen kontrolü
            if let tags = productResponse.product?.ingredients_analysis_tags {
                productResponse.product?.isVegan = tags.contains("en:vegan")
                productResponse.product?.isVegetarian = tags.contains("en:vegetarian")
                
                // 'maybe' durumları için de kontrol ekleyin
                if tags.contains("en:maybe-vegan") {
                    productResponse.product?.isVegan = nil // Belirsiz durum
                }
                if tags.contains("en:maybe-vegetarian") {
                    productResponse.product?.isVegetarian = nil // Belirsiz durum
                }
                
                // Terminale Vegan ve Vejetaryen durumunu yazdır
                print("Vegan statüsü:", productResponse.product?.isVegan == true ? "Evet" : productResponse.product?.isVegan == nil ? "Belirsiz" : "Hayır")
                print("Vejetaryen statüsü:", productResponse.product?.isVegetarian == true ? "Evet" : productResponse.product?.isVegetarian == nil ? "Belirsiz" : "Hayır")
            }
            
            completion(productResponse.product)
        } catch {
            print("JSON çözümleme hatası: \(error.localizedDescription)")
            completion(nil)
        }
    }.resume()
}
