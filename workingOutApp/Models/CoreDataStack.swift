//
//  CoreDataStack.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 05/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import CoreData

class CoreDataStack {
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
//    var container: NSPersistentContainer {
//        return persistentContainer
//    }
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Item")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
