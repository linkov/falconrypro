//
//  SDWDiaryItem+CoreDataProperties.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/8/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData


extension SDWDiaryItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SDWDiaryItem> {
        return NSFetchRequest<SDWDiaryItem>(entityName: "SDWDiaryItem")
    }

    @NSManaged public var note: String?
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var remoteID: String?
    @NSManaged public var bird: SDWBird?

}
