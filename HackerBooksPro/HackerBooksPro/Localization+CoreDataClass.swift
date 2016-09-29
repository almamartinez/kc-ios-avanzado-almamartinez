//
//  Localization+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 20/9/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import Foundation
import CoreData


public class Localization: NSManagedObject {
    static let entityName = "Localization"
    
    convenience init(note: Note, inAddress: String, longitudLocation: Float, latitudLocation: Float,
                     inContext context: NSManagedObjectContext){
        
        let ent = NSEntityDescription.entity(forEntityName: Photo.entityName, in: context)!
        
        self.init(entity: ent, insertInto: context)
        
        self.note = note
        self.address = inAddress
        self.latitude = latitudLocation
        self.longitud = longitudLocation
                
    }
}
