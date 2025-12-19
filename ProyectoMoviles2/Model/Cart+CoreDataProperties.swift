//
//  Cart+CoreDataProperties.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 18/12/25.
//
//

import Foundation
import CoreData


extension Cart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cart> {
        return NSFetchRequest<Cart>(entityName: "Cart")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var quantity: Int16
    @NSManaged public var total: Double
    @NSManaged public var product: Product?

}

extension Cart : Identifiable {

}
