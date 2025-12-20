//
//  ProductEntity+CoreDataProperties.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 18/12/25.
//
//

import Foundation
import CoreData


extension ProductEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductEntity> {
        return NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
    }

    @NSManaged public var category: String?
    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var stock: Int16
    @NSManaged public var cartItems: NSSet?

}

// MARK: Generated accessors for cartItems
extension ProductEntity {

    @objc(addCartItemsObject:)
    @NSManaged public func addToCartItems(_ value: CartEntity)

    @objc(removeCartItemsObject:)
    @NSManaged public func removeFromCartItems(_ value: CartEntity)

    @objc(addCartItems:)
    @NSManaged public func addToCartItems(_ values: NSSet)

    @objc(removeCartItems:)
    @NSManaged public func removeFromCartItems(_ values: NSSet)

}

extension ProductEntity : Identifiable {

}
