//
//  SDWBird+CoreDataProperties.swift
//  
//
//  Created by Alex Linkov on 6/15/17.
//
//

import Foundation
import CoreData


extension SDWBird {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SDWBird> {
        return NSFetchRequest<SDWBird>(entityName: "SDWBird")
    }

    @NSManaged public var birthday: NSDate?
    @NSManaged public var code: String?
    @NSManaged public var current: Bool
    @NSManaged public var dead: NSDate?
    @NSManaged public var fatWeight: Int16
    @NSManaged public var huntingWeight: Int16
    @NSManaged public var imageURL: String?
    @NSManaged public var isMale: Bool
    @NSManaged public var name: String?
    @NSManaged public var remoteID: String?
    @NSManaged public var sold: NSDate?
    @NSManaged public var thumbURL: String?
    @NSManaged public var wasDeleted: NSDate?
    @NSManaged public var diaryItems: NSSet?
    @NSManaged public var owner: SDWUser?
    @NSManaged public var seasons: NSSet?
    @NSManaged public var types: NSSet?

}

// MARK: Generated accessors for diaryItems
extension SDWBird {

    @objc(addDiaryItemsObject:)
    @NSManaged public func addToDiaryItems(_ value: SDWDiaryItem)

    @objc(removeDiaryItemsObject:)
    @NSManaged public func removeFromDiaryItems(_ value: SDWDiaryItem)

    @objc(addDiaryItems:)
    @NSManaged public func addToDiaryItems(_ values: NSSet)

    @objc(removeDiaryItems:)
    @NSManaged public func removeFromDiaryItems(_ values: NSSet)

}

// MARK: Generated accessors for seasons
extension SDWBird {

    @objc(addSeasonsObject:)
    @NSManaged public func addToSeasons(_ value: SDWSeason)

    @objc(removeSeasonsObject:)
    @NSManaged public func removeFromSeasons(_ value: SDWSeason)

    @objc(addSeasons:)
    @NSManaged public func addToSeasons(_ values: NSSet)

    @objc(removeSeasons:)
    @NSManaged public func removeFromSeasons(_ values: NSSet)

}

// MARK: Generated accessors for types
extension SDWBird {

    @objc(addTypesObject:)
    @NSManaged public func addToTypes(_ value: SDWBirdType)

    @objc(removeTypesObject:)
    @NSManaged public func removeFromTypes(_ value: SDWBirdType)

    @objc(addTypes:)
    @NSManaged public func addToTypes(_ values: NSSet)

    @objc(removeTypes:)
    @NSManaged public func removeFromTypes(_ values: NSSet)

}
