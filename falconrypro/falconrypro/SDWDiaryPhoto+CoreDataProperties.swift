//
//  SDWDiaryPhoto+CoreDataProperties.swift
//  falconrypro
//
//  Created by Alex Linkov on 8/18/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData


extension SDWDiaryPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SDWDiaryPhoto> {
        return NSFetchRequest<SDWDiaryPhoto>(entityName: "SDWDiaryPhoto")
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var lat: NSDecimalNumber?
    @NSManaged public var long: NSDecimalNumber?
    @NSManaged public var photoUrl: String?
    @NSManaged public var remoteID: String?
    @NSManaged public var thumbUrl: String?
    @NSManaged public var width: Float
    @NSManaged public var height: Float
    @NSManaged public var pinTypeTitle: String?
    @NSManaged public var diaryItem: SDWDiaryItem?
    @NSManaged public var pinType: PinType?
    @NSManaged public var quarry: SDWQuarryType?

}
