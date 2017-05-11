//
//  SDWDiaryFood+CoreDataProperties.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/10/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData


extension SDWDiaryFood {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SDWDiaryFood> {
        return NSFetchRequest<SDWDiaryFood>(entityName: "SDWDiaryFood")
    }

    @NSManaged public var remoteID: String?
    @NSManaged public var time: NSDate?
    @NSManaged public var amountEaten: Int16
    @NSManaged public var food: SDWFood?
    @NSManaged public var diaryItem: SDWDiaryItem?

}
