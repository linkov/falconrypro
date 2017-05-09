//
//  SDWFood+CoreDataProperties.swift
//  falconrypro
//
//  Created by Alex Linkov on 5/8/17.
//  Copyright © 2017 SDWR. All rights reserved.
//

import Foundation
import CoreData


extension SDWFood {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SDWFood> {
        return NSFetchRequest<SDWFood>(entityName: "SDWFood")
    }

    @NSManaged public var name: String?
    @NSManaged public var remoteID: String?

}
