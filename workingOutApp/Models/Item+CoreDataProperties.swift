//
//  Item+CoreDataProperties.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 01/02/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var descriptions: String?
    @NSManaged public var group: String?
    @NSManaged public var imageData: NSData?
    @NSManaged public var imageName: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var index: Int16
    @NSManaged public var name: String
    @NSManaged public var videoString: String?
    @NSManaged public var owner: Workouts?
    @NSManaged public var sets: NSSet?

}

// MARK: Generated accessors for sets
extension Item {

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: Sets)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: Sets)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSSet)

}
