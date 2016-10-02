//
//  Utils.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 2/10/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import Foundation
import CoreData

struct Utils {
    static func archiveURIRepresentation(ofAnObject obj: NSManagedObject) -> Data {
        let uri = obj.objectID.uriRepresentation()
        return NSKeyedArchiver.archivedData(withRootObject: uri) as Data
    }
    
    static func objectWithArchivedURIRepresentation (archivedURI: Data, context: NSManagedObjectContext) -> Book?{
        
        guard let uri = NSKeyedUnarchiver.unarchiveObject(with:archivedURI) as! URL?,
         let nid = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: uri)
        else{
            return nil
        }
        let obj = context.object(with: nid) as! Book
        if (obj.isFault){
            return obj
        }else{
            let req = NSFetchRequest<Book>(entityName: Book.entityName)
            req.predicate = NSPredicate(format: "SELF = %@",obj)
            
            do{
                
                let res = try context.fetch(req)
                if (res.count == 0){
                    return nil
                }
                return res[0] as Book
                
            }catch let e as NSError{
                print("Error while trying to perform a search: \n\(e)")
            }
        }
        return nil
    }
}
