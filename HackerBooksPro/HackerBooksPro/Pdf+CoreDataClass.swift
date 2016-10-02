//
//  Pdf+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 20/9/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import Foundation
import CoreData

let AsyncPdfDataDidEndLoading = Notification.Name(rawValue: "io.keepCoding.AsyncPdfDataDidEndLoading")
public class Pdf: NSManagedObject {

    static let entityName = "Pdf"
    
    var pdf : Data?{
        get{
            guard let data = pdfData else{
                let mainBundle = Bundle.main
                let defaultPdf = mainBundle.url(forResource: "emptyPdf", withExtension: "pdf")!
                let dt = try! Data(contentsOf: defaultPdf)
                DispatchQueue.global(qos: .default).async {
                    self.loadData()
                }
                return dt
            }
            return data as Data
        }
        
        set{
            guard let pdf = newValue else{
                pdfData = nil
                return
            }
            pdfData = pdf as NSData?
        }
    }

    
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

    private
    func loadData(){
        
        DispatchQueue.global(qos: .default).async {
            
            let tmpData = try! Data(contentsOf: URL(string: self.url!)!)
            
            DispatchQueue.main.async {
                
                self.pdf = tmpData
                //self.delegate?.asyncData(self, didEndLoadingFrom: URL(string: self.urlCover!)!)
                self.sendNotification()
            }
        }
        
        
    }

    func sendNotification(){
        
        let n = Notification(name: AsyncPdfDataDidEndLoading,
                             object: self, userInfo: ["url" : url, "data" : pdf])
        
        let nc = NotificationCenter.default
        
        nc.post(n)
        
    }

}
