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
let AsyncDataDidEndLoading = Notification.Name(rawValue: "io.keepCoding.AsyncDataDidEndLoading")
public class BookCover: NSManagedObject {

    static let entityName = "BookCover"
    weak var delegate : AsyncDataDelegate?
    
    var image : UIImage?{
        get{
            guard let data = imageCover else{
                let mainBundle = Bundle.main
                let defaultImageUrl = mainBundle.url(forResource: "emptyBookCover", withExtension: "png")!
                let dt = try! Data(contentsOf: defaultImageUrl)
                
                self.loadData()
                
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
    
    private
    func loadData(){
        
        DispatchQueue.global(qos: .default).async {
            
            let tmpData = try! Data(contentsOf: URL(string: self.urlCover!)!)
            
            DispatchQueue.main.async {
                
                self.image = UIImage(data: tmpData)
                self.delegate?.asyncData(self, didEndLoadingFrom: URL(string: self.urlCover!)!)
                self.sendNotification()
            }
        }
        
       
    }
    
    
    func sendNotification(){
        
        let n = Notification(name: AsyncDataDidEndLoading,
                             object: self, userInfo: ["url" : urlCover, "data" : imageCover])
        
        let nc = NotificationCenter.default
        
        nc.post(n)
        
    }
    


}
