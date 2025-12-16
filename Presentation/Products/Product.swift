//
//  Product.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 15/12/25.
//

import UIKit

struct Product {
    let id: UUID = UUID()
    let name: String
    let image: UIImage
    var price: String
    var stock: Int
}
