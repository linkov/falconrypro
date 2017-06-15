//
//  SDWFood+CoreDataProperties.swift
//  
//
//  Created by Alex Linkov on 6/15/17.
//
//

import Foundation
import CoreData


extension SDWFood {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SDWFood> {
        return NSFetchRequest<SDWFood>(entityName: "SDWFood")
    }

    @NSManaged public var name: String?
    @NSManaged public var popular: Bool
    @NSManaged public var remoteID: String?
    @NSManaged public var diaryFoods: NSSet?

}

// MARK: Generated accessors for diaryFoods
extension SDWFood {

    @objc(addDiaryFoodsObject:)
    @NSManaged public func addToDiaryFoods(_ value: SDWDiaryFood)

    @objc(removeDiaryFoodsObject:)
    @NSManaged public func removeFromDiaryFoods(_ value: SDWDiaryFood)

    @objc(addDiaryFoods:)
    @NSManaged public func addToDiaryFoods(_ values: NSSet)

    @objc(removeDiaryFoods:)
    @NSManaged public func removeFromDiaryFoods(_ values: NSSet)

}
