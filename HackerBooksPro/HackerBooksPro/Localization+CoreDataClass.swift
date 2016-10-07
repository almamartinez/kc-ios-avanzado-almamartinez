//
//  Localization+CoreDataClass.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 20/9/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation
import Contacts


public class Localization: NSManagedObject {
    static let entityName = "Localization"
    
    convenience init(withLocation loc: CLLocation, forNote: Note,
                     inContext context: NSManagedObjectContext){
        
        let ent = NSEntityDescription.entity(forEntityName: Localization.entityName, in: context)!
        
        self.init(entity: ent, insertInto: context)
        
        self.addToNotes(forNote)

        self.latitude = loc.coordinate.latitude
        self.longitud = loc.coordinate.longitude

        //Dirección
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(loc) { (placemarks, error) in
            if let e = error{
                print(e)
            }else{
                if let myPlacemark = placemarks?.last,
                    let myAddressDictionary = myPlacemark.addressDictionary,
                    let myAddressStrings : Array<String> = myAddressDictionary["FormattedAddressLines"] as! Array<String>?
                {
                    self.address = myAddressStrings.joined(separator: " ")
                    print("Dirección: %@",self.address)
                }
                
            }
        }
    }
}
