//
//  Pdf+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 20/9/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import Foundation
import CoreData


public class Pdf: NSManagedObject {

    static let entityName = "Pdf"
    
    convenience init(book: Book, pdfUrl: String, inContext context: NSManagedObjectContext) {
        let entidad = NSEntityDescription.entity(forEntityName: Pdf.entityName, in: context)!
        self.init(entity: entidad, insertInto: context)
        
        self.book = book
        self.url = pdfUrl
        self.pdfData = nil

    }
    
    
    convenience init(book: Book, pdfUrl: String, pdf: NSData?, inContext context: NSManagedObjectContext){
        let entidad = NSEntityDescription.entity(forEntityName: Pdf.entityName, in: context)!
        self.init(entity: entidad, insertInto: context)
        
        self.book = book
        
        self.url = pdfUrl
        self.pdfData = pdf
    }
}
