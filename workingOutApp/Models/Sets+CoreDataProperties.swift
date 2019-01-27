//
//  Sets+CoreDataProperties.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 19/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//
//

import Foundation
import CoreData


extension Sets {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sets> {
        return NSFetchRequest<Sets>(entityName: "Sets")
    }

    @NSManaged public var repeats: Int16
    @NSManaged public var weight: Double
    @NSManaged public var date: NSDate?
    @NSManaged public var item: Item

}
