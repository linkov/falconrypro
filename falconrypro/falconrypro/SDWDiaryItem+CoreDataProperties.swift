//
//  SDWDiaryItem+CoreDataProperties.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/10/17.
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
    @NSManaged public var season: SDWSeason?
    @NSManaged public var foods: NSSet?
    @NSManaged public var weights: NSSet?

}

// MARK: Generated accessors for foods
extension SDWDiaryItem {

    @objc(addFoodsObject:)
    @NSManaged public func addToFoods(_ value: SDWDiaryFood)

    @objc(removeFoodsObject:)
    @NSManaged public func removeFromFoods(_ value: SDWDiaryFood)

    @objc(addFoods:)
    @NSManaged public func addToFoods(_ values: NSSet)

    @objc(removeFoods:)
    @NSManaged public func removeFromFoods(_ values: NSSet)

}

// MARK: Generated accessors for weights
extension SDWDiaryItem {

    @objc(addWeightsObject:)
    @NSManaged public func addToWeights(_ value: SDWDiaryWeight)

    @objc(removeWeightsObject:)
    @NSManaged public func removeFromWeights(_ value: SDWDiaryWeight)

    @objc(addWeights:)
    @NSManaged public func addToWeights(_ values: NSSet)

    @objc(removeWeights:)
    @NSManaged public func removeFromWeights(_ values: NSSet)

}
