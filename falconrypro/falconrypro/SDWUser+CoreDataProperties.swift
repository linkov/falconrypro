//
//  SDWUser+CoreDataProperties.swift
//  falconrypro
//
//  Created by Alex Linkov on 6/2/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData


extension SDWUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SDWUser> {
        return NSFetchRequest<SDWUser>(entityName: "SDWUser")
    }

    @NSManaged public var isAdmin: Bool
    @NSManaged public var name: String?
    @NSManaged public var remoteID: String?
    @NSManaged public var email: String?
    @NSManaged public var birds: NSSet?
    @NSManaged public var seasons: NSSet?

}

// MARK: Generated accessors for birds
extension SDWUser {

    @objc(addBirdsObject:)
    @NSManaged public func addToBirds(_ value: SDWBird)

    @objc(removeBirdsObject:)
    @NSManaged public func removeFromBirds(_ value: SDWBird)

    @objc(addBirds:)
    @NSManaged public func addToBirds(_ values: NSSet)

    @objc(removeBirds:)
    @NSManaged public func removeFromBirds(_ values: NSSet)

}

// MARK: Generated accessors for seasons
extension SDWUser {

    @objc(addSeasonsObject:)
    @NSManaged public func addToSeasons(_ value: SDWSeason)

    @objc(removeSeasonsObject:)
    @NSManaged public func removeFromSeasons(_ value: SDWSeason)

    @objc(addSeasons:)
    @NSManaged public func addToSeasons(_ values: NSSet)

    @objc(removeSeasons:)
    @NSManaged public func removeFromSeasons(_ values: NSSet)

}
