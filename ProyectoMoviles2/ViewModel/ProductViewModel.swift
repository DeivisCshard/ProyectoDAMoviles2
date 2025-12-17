//
//  ProductViewModel.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 17/12/25.
//

import SwiftUI
import CoreData
import UIKit

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    
    private let context = CoreDataManager.shared.context
    
    init() {
        fetchProducts()
    }
    
    func fetchProducts() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            products = try context.fetch(request)
        } catch {
            print("Error fetching products: \(error)")
        }
    }
    
    func addProduct(name: String, image: UIImage, price: Double, stock: Int16, category: String) {
        let newProduct = Product(context: context)
        newProduct.id = UUID()
        newProduct.name = name
        newProduct.image = image.pngData()
        newProduct.price = price
        newProduct.stock = stock
        newProduct.category = category  // ✅ Nuevo campo

        saveContext()
    }

    func updateProduct(product: Product, name: String, image: UIImage, price: Double, stock: Int16, category: String) {
        product.name = name
        product.image = image.pngData()
        product.price = price
        product.stock = stock
        product.category = category  // ✅ Nuevo campo

        saveContext()
    }
    
    func deleteProduct(product: Product) {
        context.delete(product)
        saveContext()
    }
    
    private func saveContext() {
        CoreDataManager.shared.save()
        fetchProducts()
    }
}
