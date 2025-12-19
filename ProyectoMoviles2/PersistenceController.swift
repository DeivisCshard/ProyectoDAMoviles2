//
//  PersistenceController.swift
//  ProyectoMoviles2
//
//  Created by DESIGN on 18/12/25.
//

import CoreData

final class PersistenceController {

    // Singleton
    static let shared = PersistenceController()

    // Contenedor de Core Data
    let container: NSPersistentContainer

    // Inicializador
    private init(inMemory: Bool = false) {

        container = NSPersistentContainer(name: "ProyectoMoviles2")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("❌ Error al cargar Core Data: \(error), \(error.userInfo)")
            }
        }

        // Configuración recomendada
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
