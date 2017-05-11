//
//  SDWDiaryWeight+CoreDataProperties.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/10/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData


extension SDWDiaryWeight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SDWDiaryWeight> {
        return NSFetchRequest<SDWDiaryWeight>(entityName: "SDWDiaryWeight")
    }

    @NSManaged public var weight: Int16
    @NSManaged public var remoteID: String?
    @NSManaged public var time: NSDate?
    @NSManaged public var diaryItem: SDWDiaryItem?

}
