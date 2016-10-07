//
//  Note+CoreDataProperties.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 7/10/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import Foundation
import CoreData
 

extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note");
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var modificationDate: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var book: Book?
    @NSManaged public var localization: Localization?
    @NSManaged public var photo: Photo?

}
