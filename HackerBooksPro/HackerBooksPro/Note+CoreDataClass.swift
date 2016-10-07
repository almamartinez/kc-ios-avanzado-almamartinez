//
//  Note+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 20/9/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation
import UIKit


public class Note: NSManagedObject {
    static let  entityName = "Note"
    
    var locationManager : CLLocationManager?
    
    var hasLocation: Bool {
        get {
            return self.localization != nil
        }
    }
    
    convenience init(book: Book,
                     image: UIImage,
                     inContext context : NSManagedObjectContext){
        
        // Obtenemos la entity description
        let ent = NSEntityDescription.entity(forEntityName: Note.entityName, in: context)!
        
        // Llamamos a super
        self.init(entity: ent, insertInto: context)
        
        // Asignamos propiedades
        self.book = book
        creationDate = NSDate()
        modificationDate = NSDate()
        
        // Falta la imagen: tenemos que crear una Photo
        photo = Photo(note: self, image: image, inContext: context)
        
    }
    
    convenience init(book: Book,
                     inContext context: NSManagedObjectContext){
        
        // Obtenemos la entity description
        let ent = NSEntityDescription.entity(forEntityName: Note.entityName, in: context)!
        
        self.init(entity: ent, insertInto: context)
        
        self.book = book
        creationDate = NSDate()
        modificationDate = NSDate()
        
        // le encasquetamos una imagen vacía
        photo = Photo(note: self, inContext: context)
        
    }
    
    
    
}


//MARK: - KVO
extension Note{
    
    static func observableKeys() -> [String] {return ["text", "photo.photoData"]}
    
    func setupKVO(){
        
        // alta en las notificaciones
        // para algunas propiedades
        // Deberes: Usar un la función map
        for key in Note.observableKeys(){
            self.addObserver(self, forKeyPath: key,
                             options: [], context: nil)
        }
        
        
    }
    
    func teardownKVO(){
        
        // Baja en todas las notificaciones
        for key in Note.observableKeys(){
            self.removeObserver(self, forKeyPath: key)
        }
        
        
    }
    
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        
        // actualizar modificationDate
        modificationDate = NSDate()
        
    }
    
}

//MARK: - Lifecycle
extension Note{
    
    // Se llama una sola vez
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setupKVO()
        
        let status = CLLocationManager.authorizationStatus()
        if (((status == .authorizedAlways) || (status == .authorizedWhenInUse) || (status == .notDetermined))
            && (CLLocationManager.locationServicesEnabled())){
            
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
        }
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

extension Note : CLLocationManagerDelegate{
 
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        //lo paramos
        locationManager?.stopUpdatingLocation()
        locationManager = nil
        
        // Última localización
        if let loc = locations.last {
            let reg = NSFetchRequest<Localization>(entityName: Localization.entityName)
            let lat = NSPredicate(format: "abs(latitude) - abs(%lf) < 0.001", loc.coordinate.latitude)
            let long = NSPredicate(format: "abs(longitude) - abs(%lf) < 0.001", loc.coordinate.longitude)
            
            reg.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [lat,long])
            
            do{
                if let results = try self.managedObjectContext?.fetch(reg){
                
                    if results.count > 0{
                        let localization = results[0]
                        print("dirección: %@", localization.address)
                        localization.addToNotes(self)
                        self.localization = localization
                    }else{
                        //Creamos el Location
                         self.localization = Localization(withLocation: loc, forNote: self, inContext: self.managedObjectContext!)
                    }
                }
            }catch let e as NSError{
                print("Error while Adding a Location: \n\(e)")                
            }
            

           
        }
    }
}






