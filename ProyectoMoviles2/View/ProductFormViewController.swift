//
//  ProductFormView.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 17/12/25.
//

import SwiftUI

struct ProductFormViewController: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: ProductViewModel
    
    var productToEdit: Product? = nil
    
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var stock: String = ""
    @State private var image: UIImage? = nil
    @State private var showingImagePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)
                TextField("Stock", text: $stock)
                    .keyboardType(.numberPad)
                
                HStack {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                    }
                    Button("Select Image") {
                        showingImagePicker = true
                    }
                }
                
                Button(productToEdit == nil ? "Save" : "Update") {
                    guard let img = image,
                          let priceDouble = Double(price),
                          let stockInt = Int16(stock) else { return }
                    
                    if let editingProduct = productToEdit {
                        vm.updateProduct(product: editingProduct, name: name, image: img, price: priceDouble, stock: stockInt)
                    } else {
                        vm.addProduct(name: name, image: img, price: priceDouble, stock: stockInt)
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle(productToEdit == nil ? "New Product" : "Edit Product")
            .onAppear {
                if let product = productToEdit {
                    name = product.name ?? ""
                    price = String(product.price)
                    stock = String(product.stock)
                    if let data = product.image, let uiImage = UIImage(data: data) {
                        image = uiImage
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $image)
            }
        }
    }
}
