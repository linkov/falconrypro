//
//  SDWSeason+CoreDataProperties.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/10/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData


extension SDWSeason {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SDWSeason> {
        return NSFetchRequest<SDWSeason>(entityName: "SDWSeason")
    }

    @NSManaged public var startDate: NSDate?
    @NSManaged public var endDate: NSDate?
    @NSManaged public var isBetweenSeason: Bool
    @NSManaged public var remoteID: String?
    @NSManaged public var startDateString: String?
    @NSManaged public var endDateString: String?
    @NSManaged public var user: SDWUser?
    @NSManaged public var bird: SDWBird?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension SDWSeason {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: SDWDiaryItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: SDWDiaryItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
