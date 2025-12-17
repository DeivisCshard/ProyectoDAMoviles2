//
//  Product+CoreDataProperties.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 17/12/25.
//

import Foundation
import CoreData

extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var image: Data?
    @NSManaged public var price: Double
    @NSManaged public var stock: Int16
}
