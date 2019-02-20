//
//  Workouts+CoreDataProperties.swift
//  
//
//  Created by Rusłan Chamski on 21/02/2019.
//
//

import Foundation
import CoreData


extension Workouts {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workouts> {
        return NSFetchRequest<Workouts>(entityName: "Workouts")
    }

    @NSManaged public var imageName: NSData?
    @NSManaged public var index: Int16
    @NSManaged public var name: String?
    @NSManaged public var userName: String?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension Workouts {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
