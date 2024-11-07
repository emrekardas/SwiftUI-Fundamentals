//
//  fetchProductInfo.swift
//  Barcode-Scanner
//
//  Created by Emre KARDAS on 11/5/24.
//
//
//  fetchProductInfo.swift
//  Barcode-Scanner
//
//  Created by Emre KARDAS on 11/5/24.
//

import Foundation

// Ana API yanıt yapısı
struct OpenFoodFactsResponse: Codable {
    let code: String?
    var product: Product?
    let status: Int?
}

// Ürün yapısı
struct Product: Codable {
    let product_name: String?
    let image_url: String?
    let ingredients_text: String?
    let categories: String?
    let brands: String?
    let quantity: String?
    let nutriments: Nutriments?
    let stores: StoresType?
    let ingredients_analysis_tags: [String]
    var isVegan: Bool?
    var isVegetarian: Bool?
    var isGlutenFree: Bool?
}

// Mağaza türleri
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

// Besin değerleri
struct Nutriments: Codable {
    let energyKcal100g: Double?
    let fat: Double?
    let saturated_fat: Double?
    let sugars: Double?
    let salt: Double?

    enum CodingKeys: String, CodingKey {
        case energyKcal100g = "energy-kcal_100g"
        case fat
        case saturated_fat
        case sugars
        case salt
    }
}

// Bileşen özellikleri için yapı
struct IngredientProperty: Codable {
    let name: String
    let vegan: Bool
    let vegetarian: Bool
    let gluten_free: Bool
}

// JSON dosyasından bileşen özelliklerini yükleyen fonksiyon
func loadIngredientProperties() -> [IngredientProperty]? {
    guard let url = Bundle.main.url(forResource: "ingredients_reference", withExtension: "json") else {
        print("JSON dosyası bulunamadı.")
        return nil
    }
    do {
        let data = try Data(contentsOf: url)
        let rootObject = try JSONDecoder().decode([String: [IngredientProperty]].self, from: data)
        return rootObject["ingredients"]
    } catch {
        print("JSON dosyası çözümlenirken hata oluştu: \(error)")
        return nil
    }
}

// ingredients_text içindeki bileşenleri ayıran yardımcı fonksiyon
func parseIngredients(from ingredientsText: String) -> [String] {
    let separators = CharacterSet(charactersIn: ",;")
    return ingredientsText
        .components(separatedBy: separators)
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }
}

// Bileşenleri analiz eden fonksiyon
func analyzeProductIngredients(ingredientsText: String) -> (isVegan: Bool, isVegetarian: Bool, isGlutenFree: Bool) {
    let ingredients = parseIngredients(from: ingredientsText)
    guard let ingredientProperties = loadIngredientProperties() else {
        return (isVegan: false, isVegetarian: false, isGlutenFree: false)
    }

    var isVegan = true
    var isVegetarian = true
    var isGlutenFree = true

    for ingredient in ingredients {
        if let property = ingredientProperties.first(where: { $0.name.lowercased() == ingredient.lowercased() }) {
            if !property.vegan { isVegan = false }
            if !property.vegetarian { isVegetarian = false }
            if !property.gluten_free { isGlutenFree = false }
        } else {
            print("\(ingredient) için özellik bulunamadı, analiz dışı bırakılıyor.")
        }
    }

    return (isVegan, isVegetarian, isGlutenFree)
}

// API'den ürün bilgilerini getiren ana fonksiyon
func fetchProductInfo(for code: String, completion: @escaping (Product?) -> Void) {
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

            // API'den gelen vegan ve vejetaryen analiz etiketlerini kontrol et
            if let tags = productResponse.product?.ingredients_analysis_tags {
                productResponse.product?.isVegan = tags.contains("en:vegan")
                productResponse.product?.isVegetarian = tags.contains("en:vegetarian")
            }

            // ingredients_text'i parse ederek bileşenleri kontrol et
            if let ingredientsText = productResponse.product?.ingredients_text {
                let analysisResult = analyzeProductIngredients(ingredientsText: ingredientsText)
                productResponse.product?.isVegan = analysisResult.isVegan
                productResponse.product?.isVegetarian = analysisResult.isVegetarian
                productResponse.product?.isGlutenFree = analysisResult.isGlutenFree
                
                print("Vegan statüsü:", analysisResult.isVegan ? "Evet" : "Hayır")
                print("Vejetaryen statüsü:", analysisResult.isVegetarian ? "Evet" : "Hayır")
                print("Glutensiz mi:", analysisResult.isGlutenFree ? "Evet" : "Hayır")
            }

            completion(productResponse.product)
        } catch {
            print("JSON çözümleme hatası: \(error.localizedDescription)")
            completion(nil)
        }
    }.resume()
}

