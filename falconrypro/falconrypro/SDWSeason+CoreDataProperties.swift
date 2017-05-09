//
//  SDWSeason+CoreDataProperties.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/8/17.
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
    @NSManaged public var user: SDWUser?

}
