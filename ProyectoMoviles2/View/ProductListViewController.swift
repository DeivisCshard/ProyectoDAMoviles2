//
//  ProductListView.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 17/12/25.
//

import SwiftUI

struct ProductListViewController: View {
    @StateObject var vm = ProductViewModel()
    @State private var showingAdd = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.products, id: \.id) { product in
                    NavigationLink(destination: ProductFormView(vm: vm, productToEdit: product)) {
                        HStack {
                            if let data = product.image, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                            }
                            VStack(alignment: .leading) {
                                Text(product.name ?? "")
                                    .font(.headline)
                                Text("Stock: \(product.stock) - $\(product.price, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let product = vm.products[index]
                        vm.deleteProduct(product: product)
                    }
                }
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAdd = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                ProductFormView(vm: vm)
            }
        }
    }
}
