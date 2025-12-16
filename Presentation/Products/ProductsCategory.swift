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

    var images: [UIImage] {
        switch self {
        case .tazas:
            return [
                UIImage(named: "taza1")!,
                UIImage(named: "taza1")!,
                UIImage(named: "taza1")!,
                UIImage(named: "taza1")!
            ]
        case .ropa:
            return [
                UIImage(named: "ropa1")!,
                UIImage(named: "ropa1")!,
                UIImage(named: "ropa1")!,
                UIImage(named: "ropa1")!
            ]
        case .luces:
            return [
                UIImage(named: "luces11")!,
                UIImage(named: "luces11")!,
                UIImage(named: "luces11")!,
                UIImage(named: "luces11")!
            ]
        case .juguetes:
            return [
                UIImage(named: "juguete1")!,
                UIImage(named: "juguete1")!,
                UIImage(named: "juguete1")!,
                UIImage(named: "juguete1")!
            ]
        }
    }
}
