//
//  Book+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 20/9/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import Foundation
import CoreData


public class Book: NSManagedObject {

    static let entityName = "Book"
    
    convenience init(title: String, authors:[String], urlCover: String, urlPdf: String, inContext context: NSManagedObjectContext){
        let entidad = NSEntityDescription.entity(forEntityName: Book.entityName, in: context)!
        self.init(entity: entidad, insertInto: context)
        
        self.tittle = title
        
        
        self.pdf = Pdf(book: self, pdfUrl: urlPdf, inContext: context)
        self.bookCover = BookCover(book: self, imageUrl: urlCover, inContext: context)
        
        authors.forEach{
           addToAuthors(Author(book: self, name: $0, inContext: context))
        }
    }
    
    func formattedListOfAuthors() -> String {
                
        let auths = self.authors?.allObjects as! [Author]
        return auths.map{$0.name!}.joined(separator: ", ").capitalized
    }
    
    func formattedListOfTags() -> String {
        
        let btags = (self.bookTags?.allObjects) as! [BookTag]
        
        return btags.map{$0.tag!}.map{$0.name!}.joined(separator: ", ").capitalized
    }

}

/*

//MARK: - KVO: Key Value Observer
extension Book{
    static func observableKeys() -> [String] {return ["name", "booksTag"]}
    
    func setupKVO(){
        
        // alta en las notificaciones
        // para algunas propiedades
        // Deberes: Usar un la función map
        for key in Book.observableKeys(){
            self.addObserver(self, forKeyPath: key,
                             options: [], context: nil)
        }
        
        
    }
    
    func teardownKVO(){
        
        // Baja en todas las notificaciones
        for key in Book.observableKeys(){
            self.removeObserver(self, forKeyPath: key)
        }
        
        
    }
}


//MARK: - Lifecycle
extension Book{
    
    // Se llama una sola vez
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setupKVO()
    }
    
    // Se llama un huevo de veces
    public override func awakeFromFetch() {
        super.awakeFromFetch()
        
        setupKVO()
    }
    
    public override func willTurnIntoFault() {
        super.willTurnIntoFault()
        
        teardownKVO()
    }
}
 */
