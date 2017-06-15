//
//  SDWDiaryWeight+CoreDataProperties.swift
//  
//
//  Created by Alex Linkov on 6/15/17.
//
//

import Foundation
import CoreData


extension SDWDiaryWeight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SDWDiaryWeight> {
        return NSFetchRequest<SDWDiaryWeight>(entityName: "SDWDiaryWeight")
    }

    @NSManaged public var remoteID: String?
    @NSManaged public var time: NSDate?
    @NSManaged public var weight: Int16
    @NSManaged public var diaryItem: SDWDiaryItem?

}
