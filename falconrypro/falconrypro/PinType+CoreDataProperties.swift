//
//  PinType+CoreDataProperties.swift
//  falconrypro
//
//  Created by Alex Linkov on 6/15/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData


extension PinType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PinType> {
        return NSFetchRequest<PinType>(entityName: "PinType")
    }

    @NSManaged public var remoteID: String?
    @NSManaged public var title: String?
    @NSManaged public var pins: NSSet?
    @NSManaged public var photos: SDWDiaryPhoto?

}

// MARK: Generated accessors for pins
extension PinType {

    @objc(addPinsObject:)
    @NSManaged public func addToPins(_ value: SDWPinItem)

    @objc(removePinsObject:)
    @NSManaged public func removeFromPins(_ value: SDWPinItem)

    @objc(addPins:)
    @NSManaged public func addToPins(_ values: NSSet)

    @objc(removePins:)
    @NSManaged public func removeFromPins(_ values: NSSet)

}
