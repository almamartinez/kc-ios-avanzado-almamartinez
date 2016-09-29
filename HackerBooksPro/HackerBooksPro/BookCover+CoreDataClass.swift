//
//  BookCover+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 20/9/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class BookCover: NSManagedObject {

    static let entityName = "BookCover"
    
    var image : UIImage?{
        get{
            guard let data = imageCover else{
                let mainBundle = Bundle.main
                let defaultImageUrl = mainBundle.url(forResource: "emptyBookCover", withExtension: "png")!
                let dt = try! Data(contentsOf: defaultImageUrl)
                return UIImage(data: dt)
            }
            return  UIImage(data : data as Data)!
        }
        
        set{
            guard let img = newValue else{
                imageCover = nil
                return
            }
            imageCover = UIImageJPEGRepresentation(img, 0.9) as NSData?
        }
    }
    
    convenience init(book: Book, imageUrl: String, inContext context: NSManagedObjectContext){
        let entidad = NSEntityDescription.entity(forEntityName: BookCover.entityName, in: context)!
        self.init(entity: entidad, insertInto: context)
        
        self.book = book
        
        self.urlCover = imageUrl
        self.image = nil
    }
    
    convenience init(book: Book, imageUrl: String, image : UIImage, inContext context: NSManagedObjectContext){
        let entidad = NSEntityDescription.entity(forEntityName: BookCover.entityName, in: context)!
        self.init(entity: entidad, insertInto: context)
        
        self.book = book
        
        self.urlCover = imageUrl
        self.image = image
    }
}
