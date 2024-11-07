//
//  ProductDetailView.swift
//  Barcode-Scanner
//
//  Created by Emre KARDAS on 11/5/24.
//
import SwiftUI

struct ProductDetailView: View {
    @Binding var product: Product?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Ürün Görseli
                if let imageUrlString = product?.image_url, let imageUrl = URL(string: imageUrlString) {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(8)
                    } placeholder: {
                        ProgressView()
                    }
                    .padding(.bottom, 8)
                }

                // Ürün Adı ve Vegan/Vejetaryen Durumu
                Text(product?.product_name?.uppercased() ?? "Ürün Adı Bulunamadı")
                    .font(.title)
                    .fontWeight(.bold)
                
                HStack(spacing: 16) {
                    // Vegan durumu
                    if let isVegan = product?.isVegan, isVegan {
                        HStack(spacing: 4) {
                            Image("vegan")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }

                    // Vejetaryen durumu
                    if let isVegetarian = product?.isVegetarian, isVegetarian {
                        HStack(spacing: 4) {
                            Image("vegetarian")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }

                    // Gluten-Free durumu
                    if let isGlutenFree = product?.isGlutenFree, isGlutenFree {
                        HStack(spacing: 4) {
                            Image("gluten-free")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                }
                .font(.title2)
                .padding(.vertical, 8)


                Divider()

                // İçindekiler
                if let ingredients = product?.ingredients_text {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("İçindekiler")
                            .font(.headline)
                        Text(ingredients)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                } else {
                    Text("İçindekiler bilgisi bulunamadı.")
                        .foregroundColor(.gray)
                }

                // Kategori
                if let category = product?.categories {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Kategori")
                            .font(.headline)
                        Text(category)
                            .font(.body)
                    }
                } else {
                    Text("Kategori bilgisi bulunamadı.")
                        .foregroundColor(.gray)
                }

                // Marka
                if let brand = product?.brands {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Marka")
                            .font(.headline)
                        Text(brand)
                            .font(.body)
                    }
                } else {
                    Text("Marka bilgisi bulunamadı.")
                        .foregroundColor(.gray)
                }

                // Miktar
                if let quantity = product?.quantity {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Miktar")
                            .font(.headline)
                        Text(quantity)
                            .font(.body)
                    }
                } else {
                    Text("Miktar bilgisi bulunamadı.")
                        .foregroundColor(.gray)
                }

                Divider()

                // Besin Değerleri
                if let nutriments = product?.nutriments {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Besin Değerleri (100g)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.vertical, 8)
                        
                        if let energyKcal100g = nutriments.energyKcal100g {
                            Text("Enerji: \(Int(energyKcal100g)) kcal")
                                .font(.body)
                        } else {
                            Text("Enerji bilgisi bulunamadı.")
                        }
                        if let fat = nutriments.fat {
                            Text("Yağ: \(fat) g")
                                .font(.body)
                        } else {
                            Text("Yağ bilgisi bulunamadı.")
                        }
                        if let saturatedFat = nutriments.saturated_fat {
                            Text("Doymuş Yağ: \(saturatedFat) g")
                                .font(.body)
                        } else {
                            Text("Doymuş Yağ bilgisi bulunamadı.")
                        }
                        if let sugars = nutriments.sugars {
                            Text("Şeker: \(sugars) g")
                                .font(.body)
                        } else {
                            Text("Şeker bilgisi bulunamadı.")
                        }
                        if let salt = nutriments.salt {
                            Text("Tuz: \(salt) g")
                                .font(.body)
                        } else {
                            Text("Tuz bilgisi bulunamadı.")
                        }
                    }
                } else {
                    Text("Besin bilgisi bulunamadı.")
                        .foregroundColor(.gray)
                        .padding(.top)
                }

                Divider()
            }
            .padding()
            .navigationTitle("Ürün Detayları")
        }
        .background(Color.veganBackground) // veganBackground rengi burada uygulandı
        .edgesIgnoringSafeArea(.all) // Arka planın tüm ekranı kaplaması için
    }
}

