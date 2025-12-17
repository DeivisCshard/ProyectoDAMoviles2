//
//  ProductsCategory.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 15/12/25.
//

import UIKit

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

    var products: [Product] {
        switch self {
        case .tazas:
            return [
                Product(name: "Taza Santa", image: UIImage(named: "taza1")!, price: 30.0, stock: 5),
                Product(name: "Taza Reno", image: UIImage(named: "taza1")!, price: 30.0, stock: 5),
                Product(name: "Taza Árbol", image: UIImage(named: "taza1")!, price: 30.0, stock: 5),
                Product(name: "Taza Navidad", image: UIImage(named: "taza1")!, price: 30.0, stock: 5)
            ]
        case .ropa:
            return [
                Product(name: "Polo Noel", image: UIImage(named: "ropa1")!, price: 45.0, stock: 3),
                Product(name: "Chompa Xmas", image: UIImage(named: "ropa1")!, price: 60.0, stock: 4),
                Product(name: "Gorro", image: UIImage(named: "ropa1")!, price: 20.0, stock: 6),
                Product(name: "Bufanda", image: UIImage(named: "ropa1")!, price: 25.0, stock: 2)
            ]
        case .luces:
            return [
                Product(name: "Luces LED", image: UIImage(named: "luces11")!, price: 50.0, stock: 10),
                Product(name: "Luces Estrella", image: UIImage(named: "luces11")!, price: 55.0, stock: 8),
                Product(name: "Luces Árbol", image: UIImage(named: "luces11")!, price: 40.0, stock: 7),
                Product(name: "Luces Exterior", image: UIImage(named: "luces11")!, price: 70.0, stock: 3)
            ]
        case .juguetes:
            return [
                Product(name: "Muñeco Santa", image: UIImage(named: "juguete1")!, price: 35.0, stock: 4),
                Product(name: "Tren Navidad", image: UIImage(named: "juguete1")!, price: 80.0, stock: 2),
                Product(name: "Oso Noel", image: UIImage(named: "juguete1")!, price: 45.0, stock: 5),
                Product(name: "Set Juguetes", image: UIImage(named: "juguete1")!, price: 90.0, stock: 1)
            ]
        }
    }

}
