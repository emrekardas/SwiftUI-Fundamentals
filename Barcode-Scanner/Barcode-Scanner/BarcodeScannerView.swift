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
    @State private var showProductDetail = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Barkod Tarayıcı")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                ScannerView(scannedBarcode: $scannedBarcode)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .padding(.horizontal)
                
                VStack(spacing: 10) {
                    Label("Taranan Barkod:", systemImage: "barcode.viewfinder")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
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
                            if !scannedBarcode.isEmpty {
                                UIPasteboard.general.string = scannedBarcode
                                isShowingCopiedAlert = true
                            }
                        }
                        .onChange(of: scannedBarcode) { newBarcode in
                            fetchProductInfo(for: newBarcode) { fetchedProduct in
                                DispatchQueue.main.async {
                                    self.product = fetchedProduct
                                    self.showProductDetail = fetchedProduct != nil
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
                    
                    if let _ = product {
                        Button(action: {
                            showProductDetail = true
                        }) {
                            Text("Ürün Detaylarını Görüntüle")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .sheet(isPresented: $showProductDetail) {
                            ProductDetailView(product: $product)
                                .presentationDetents([.large]) // Tam ekran olarak açar
                                .presentationDragIndicator(.hidden) // Çekme göstergesini gizler
                        }
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
