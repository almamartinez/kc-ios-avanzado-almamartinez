//
//  Localization+CoreDataProperties.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 20/9/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import Foundation
import CoreData
 

extension Localization {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Localization> {
        return NSFetchRequest<Localization>(entityName: "Localization");
    }

    @NSManaged public var longitud: Float
    @NSManaged public var latitude: Float
    @NSManaged public var address: String?
    @NSManaged public var note: Note?

}
