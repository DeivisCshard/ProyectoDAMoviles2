//
//  ProductsCategory.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 15/12/25.
//

import UIKit
import CoreData

enum ProductsCategory: CaseIterable {
    case tazas
    case ropa
    case luces
    case juguetes

    var title: String {
        switch self {
        case .tazas: return "Tazas"
        case .ropa: return "Ropa"
        case .luces: return "Luces"
        case .juguetes: return "Juguetes"
        }
    }
    
    func fetchProducts(context: NSManagedObjectContext) -> [ProductEntity] {
        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        request.predicate = NSPredicate(format: "category == %@", title)
        return (try? context.fetch(request)) ?? []
    }
    
    func fetchCartItems(context: NSManagedObjectContext) -> [CartEntity] {
        let request: NSFetchRequest<CartEntity> = CartEntity.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }

}


