//
//  SDWBirdType+CoreDataProperties.swift
//  
//
//  Created by Alex Linkov on 6/15/17.
//
//

import Foundation
import CoreData


extension SDWBirdType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SDWBirdType> {
        return NSFetchRequest<SDWBirdType>(entityName: "SDWBirdType")
    }

    @NSManaged public var isPopular: Bool
    @NSManaged public var latin: String?
    @NSManaged public var name: String?
    @NSManaged public var order: Int32
    @NSManaged public var remoteID: String?
    @NSManaged public var birds: NSSet?

}

// MARK: Generated accessors for birds
extension SDWBirdType {

    @objc(addBirdsObject:)
    @NSManaged public func addToBirds(_ value: SDWBird)

    @objc(removeBirdsObject:)
    @NSManaged public func removeFromBirds(_ value: SDWBird)

    @objc(addBirds:)
    @NSManaged public func addToBirds(_ values: NSSet)

    @objc(removeBirds:)
    @NSManaged public func removeFromBirds(_ values: NSSet)

}
