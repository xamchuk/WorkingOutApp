//
//  Item+CoreDataProperties.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 16/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var name: String
    @NSManaged public var imageURL: String?
    @NSManaged public var rounds: Int16
    @NSManaged public var amount: Int16
    @NSManaged public var weight: Double
    @NSManaged public var videoString: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var group: String?
    @NSManaged public var imageName: String?
    @NSManaged public var imageData: NSData?

}
