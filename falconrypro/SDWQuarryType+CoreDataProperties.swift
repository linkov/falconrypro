//
//  SDWQuarryType+CoreDataProperties.swift
//  
//
//  Created by Alex Linkov on 6/15/17.
//
//

import Foundation
import CoreData


extension SDWQuarryType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SDWQuarryType> {
        return NSFetchRequest<SDWQuarryType>(entityName: "SDWQuarryType")
    }

    @NSManaged public var name: String?
    @NSManaged public var remoteID: String?
    @NSManaged public var diaryItems: NSSet?
    @NSManaged public var photos: SDWDiaryPhoto?

}

// MARK: Generated accessors for diaryItems
extension SDWQuarryType {

    @objc(addDiaryItemsObject:)
    @NSManaged public func addToDiaryItems(_ value: SDWDiaryItem)

    @objc(removeDiaryItemsObject:)
    @NSManaged public func removeFromDiaryItems(_ value: SDWDiaryItem)

    @objc(addDiaryItems:)
    @NSManaged public func addToDiaryItems(_ values: NSSet)

    @objc(removeDiaryItems:)
    @NSManaged public func removeFromDiaryItems(_ values: NSSet)

}
