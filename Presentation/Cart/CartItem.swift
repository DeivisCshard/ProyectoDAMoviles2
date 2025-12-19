//
//  CartItem.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 18/12/25.
//

import UIKit

struct CartItem {
    let product: Product
    var quantity: Int
    var subtotal: Double { return Double(quantity) * product.price }
}
