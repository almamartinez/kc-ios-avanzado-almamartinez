//
//  Tag+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 20/9/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import Foundation
import CoreData

struct TagConstants{
    static let favoriteTag = "Favorite"
}
public class Tag: NSManagedObject {

    static let entityName = "Tag"
    
    convenience init(name: String, inContext context: NSManagedObjectContext){
        let entidad = NSEntityDescription.entity(forEntityName: Tag.entityName, in: context)!
        self.init(entity: entidad, insertInto: context)
        self.order = name.uppercased()
        if (self.order == TagConstants.favoriteTag.uppercased()){
            self.order?.insert("_", at: (self.order?.startIndex)!)
        }
        self.name = name
    }    
}




//MARK: - KVO: Key Value Observer
/*extension Tag{
    static func observableKeys() -> [String] {return ["name", "booksTag"]}
    
    func setupKVO(){
        
        // alta en las notificaciones
        // para algunas propiedades
        // Deberes: Usar un la función map
        for key in Tag.observableKeys(){
            self.addObserver(self, forKeyPath: key,
                             options: [], context: nil)
        }
        
        
    }
    
    func teardownKVO(){
        
        // Baja en todas las notificaciones
        for key in Tag.observableKeys(){
            self.removeObserver(self, forKeyPath: key)
        }
    }
    
}


//MARK: - Lifecycle
extension Tag{
    
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
