//
//  Tag+CoreDataProperties.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 5/10/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import Foundation
import CoreData
 

extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag");
    }

    @NSManaged public var name: String?
    @NSManaged public var order: String?
    @NSManaged public var booksTag: NSSet?

}

// MARK: Generated accessors for booksTag
extension Tag {

    @objc(addBooksTagObject:)
    @NSManaged public func addToBooksTag(_ value: BookTag)

    @objc(removeBooksTagObject:)
    @NSManaged public func removeFromBooksTag(_ value: BookTag)

    @objc(addBooksTag:)
    @NSManaged public func addToBooksTag(_ values: NSSet)

    @objc(removeBooksTag:)
    @NSManaged public func removeFromBooksTag(_ values: NSSet)

}
