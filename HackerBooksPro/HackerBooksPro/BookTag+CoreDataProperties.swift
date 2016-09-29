//
//  BookTag+CoreDataProperties.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 24/9/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import Foundation
import CoreData
 

extension BookTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookTag> {
        return NSFetchRequest<BookTag>(entityName: "BookTag");
    }

    @NSManaged public var book: Book?
    @NSManaged public var tag: Tag?

}
