//
//  BookTag+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 20/9/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import Foundation
import CoreData


public class BookTag: NSManagedObject {
    static let entityName = "BookTag"
    
    convenience init(book: Book, tag: Tag, inContext context: NSManagedObjectContext){
        let entidad = NSEntityDescription.entity(forEntityName: BookTag.entityName, in: context)!
        self.init(entity: entidad, insertInto: context)
        
        self.book = book
        self.tag = tag
        
    }

}
/*
//MARK: - KVO: Key Value Observer
extension BookTag{
    static func observableKeys() -> [String] {return ["book", "tag"]}
    
    func setupKVO(){
        
        // alta en las notificaciones
        // para algunas propiedades
        for key in BookTag.observableKeys(){
            self.addObserver(self, forKeyPath: key,
                             options: [], context: nil)
        }
        
        
    }
    
    func teardownKVO(){
        
        // Baja en todas las notificaciones
        for key in BookTag.observableKeys(){
            self.removeObserver(self, forKeyPath: key)
        }
        
        
    }
    
}


//MARK: - Lifecycle
extension BookTag{
    
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
