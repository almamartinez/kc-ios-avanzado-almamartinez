//
//  Pdf+CoreDataProperties.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 22/9/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import Foundation
import CoreData
 

extension Pdf {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pdf> {
        return NSFetchRequest<Pdf>(entityName: "Pdf");
    }

    @NSManaged public var pdfData: NSData?
    @NSManaged public var url: String?
    @NSManaged public var book: Book?

}
