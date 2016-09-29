//
//  BookCover+CoreDataProperties.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 24/9/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import Foundation
import CoreData


extension BookCover {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookCover> {
        return NSFetchRequest<BookCover>(entityName: "BookCover");
    }

    @NSManaged public var imageCover: NSData?
    @NSManaged public var urlCover: String?
    @NSManaged public var book: Book?

}
