//
//  ContentView.swift
//  Barcode-Scanner
//
//  Created by Emre KARDAS on 11/5/24.
//

import SwiftUI

struct BarcodeScannerView: View {
    @State private var scannedBarcode = ""
    @State private var product: Product? // API'den gelen ürün bilgisi
    @State private var isShowingCopiedAlert = false
    @State private var animate = false
    @State private var apiKey = "cqaevq7jtd96ekl6hs2rtshrezmnkl" // API anahtarınızı buraya ekleyin

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // Başlık
                Text("Barkod Tarayıcı")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                // Barkod Tarayıcı Kamera Görünümü
                ScannerView(scannedBarcode: $scannedBarcode)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding(.horizontal)
                
                // Barkod Bilgisi ve Ürün Detayları
                VStack(spacing: 10) {
                    Label("Taranan Barkod:", systemImage: "barcode.viewfinder")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    // Barkod Metni
                    Text(scannedBarcode.isEmpty ? "Henüz Tarama Yapılmadı" : scannedBarcode)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(scannedBarcode.isEmpty ? .red : .green)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .scaleEffect(animate ? 1.1 : 1.0)
                        .opacity(animate ? 1.0 : 0.7)
                        .onTapGesture {
                            // Barkodu kopyalama ve alert gösterme
                            if !scannedBarcode.isEmpty {
                                UIPasteboard.general.string = scannedBarcode
                                isShowingCopiedAlert = true
                            }
                        }
                        .onChange(of: scannedBarcode) { newBarcode in
                            // Barkod değiştiğinde API'yi çağır
                            fetchProductInfo(for: newBarcode, apiKey: apiKey) { fetchedProduct in
                                DispatchQueue.main.async {
                                    self.product = fetchedProduct
                                    
                                    // Animasyon tetikleme
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        animate = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            animate = false
                                        }
                                    }
                                }
                            }
                        }
                    
                    // Ürün Bilgileri
                    if let product = product {
                        VStack(alignment: .leading, spacing: 12) {
                            if let imageUrlString = product.images?.first,
                               let imageUrl = URL(string: imageUrlString) {
                                AsyncImage(url: imageUrl) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 120)
                                        .cornerRadius(8)
                                } placeholder: {
                                    ProgressView()
                                }
                                .padding(.bottom, 8)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                if let description = product.description {
                                    Text(description)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .lineLimit(3)
                                } else {
                                    Text("Açıklama Bulunamadı")
                                        .font(.body)
                                        .foregroundColor(.gray)
                                }

                                HStack {
                                    Text("Kategori:")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(product.category ?? "Bilinmiyor")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }

                                HStack {
                                    Text("Marka:")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(product.brand ?? "Bilinmiyor")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    } else {
                        Text("Ürün Bilgisi Bulunamadı")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding(.top, 20)

                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .alert(isPresented: $isShowingCopiedAlert) {
                Alert(title: Text("Kopyalandı"), message: Text("Barkod panoya kopyalandı."), dismissButton: .default(Text("Tamam")))
            }
        }
    }
}

#Preview {
    BarcodeScannerView()
}
