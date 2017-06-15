//
//  SDWPinItem+CoreDataProperties.swift
//  
//
//  Created by Alex Linkov on 6/15/17.
//
//

import Foundation
import CoreData


extension SDWPinItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SDWPinItem> {
        return NSFetchRequest<SDWPinItem>(entityName: "SDWPinItem")
    }

    @NSManaged public var imageURL: String?
    @NSManaged public var lat: NSDecimalNumber?
    @NSManaged public var long: NSDecimalNumber?
    @NSManaged public var note: String?
    @NSManaged public var pinTypeName: String?
    @NSManaged public var remoteID: String?
    @NSManaged public var thumbURL: String?
    @NSManaged public var diaryItem: SDWDiaryItem?
    @NSManaged public var pintype: PinType?

}
