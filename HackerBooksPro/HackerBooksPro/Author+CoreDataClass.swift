//
//  Author+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 20/9/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import Foundation
import CoreData


public class Author: NSManagedObject {
    
    static let entityName = "Author"
    
    convenience init(book: Book, name: String, inContext context: NSManagedObjectContext){
        let entidad = NSEntityDescription.entity(forEntityName: Author.entityName, in: context)!
        self.init(entity: entidad, insertInto: context)
        
        self.name = name
        
        addToBooks(book)
        
    }
}
