//
//  AppDelegate.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 18/9/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import UIKit
import Foundation
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    static let model = CoreDataStack(modelName: "Model")!
    static let urlJSON = "https://t.co/K9ziV0z3SJ"
    

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Create the window
        window = UIWindow.init(frame: UIScreen.main.bounds)
        initializeData(doIt: false)
        // Create the model
        loadDataFirstTime()
        // Create the rootVC
        //let rootVC = LibraryViewController(model: model!, style: .plain)
        //window?.rootViewController = rootVC.wrappedInNavigationController()
        
        return true
    }
    
    // Función para vaciar los datos, según el parámetro que le pasemos
    func initializeData(doIt: Bool){
        if doIt {
            do{
                try AppDelegate.model.dropAllData()
                let usrDef = UserDefaults()
                usrDef.removeObject(forKey: AppDelegate.FirstLoadKey)
                
            }catch{
                fatalError("Error while dropping data from model")
            }
        }
    }
    
    
    func loadDataToTableView()
    {
        // Creamos el fetchRequest
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        fr.fetchBatchSize = 50
        
        let sd = NSSortDescriptor(key: "tag.name", ascending: true)
        let sd2 = NSSortDescriptor(key: "book.tittle", ascending: true)
        
        fr.sortDescriptors = [sd, sd2]
         
        // Creamos el fetchedResultsCtrl
        let fc = NSFetchedResultsController(fetchRequest: fr,
                                            managedObjectContext: AppDelegate.model.context,
                                            sectionNameKeyPath: "tag.name",
                                            cacheName: nil)
 
        
        // Creamos el rootVC
        let nVC = LibraryViewController(fetchedResultsController: fc as! NSFetchedResultsController<NSFetchRequestResult>, style: .grouped)
        let navVC = UINavigationController(rootViewController: nVC)
        //Buscamos el último libro, por si existiese:
        let usrDef = UserDefaults()
        
        if let b = usrDef.value(forKey: AppDelegate.LastBookVisitedKey) as! Data?,
            let book = Utils.objectWithArchivedURIRepresentation(archivedURI: b, context: AppDelegate.model.context){
            // Create the VC
            let bookVC = BookViewController(model: book)
            navVC.pushViewController(bookVC, animated: true)
        }
        
        self.window?.rootViewController = navVC
        // Display
        self.window?.makeKeyAndVisible()
        

    }
    
    static let FirstLoadKey = "FirstLoadKey"
    static let LastBookVisitedKey = "LastBookVisited"
    
    func loadDataFirstTime()  {
        //Miramos si es la primera vez que se abre la app.
        let usrDef = UserDefaults()
        if usrDef.object(forKey: AppDelegate.FirstLoadKey) != nil{
            
           loadDataToTableView()
            return
        }else{
            let modalVC = ModalViewController()
            window?.rootViewController = modalVC
            // Display
            window?.makeKeyAndVisible()
            // Cargamos los libros del pdf, que traemos de interné.
            DispatchQueue.global(qos: .default).async {
                do{
                    let tmpData = try! Data(contentsOf: URL(string: AppDelegate.urlJSON)!)
                    let jsonDicts = try JSONSerialization.jsonObject(with: tmpData, options: .allowFragments) as? JSONArray
                    DispatchQueue.main.async {
                        //Marcamos como hecha la primera carga
                        usrDef.setValue(true, forKey: AppDelegate.FirstLoadKey)
                        AppDelegate.model.performBackgroundBatchOperation({ (bg) in
                            let books = try! decode(books: jsonDicts, bgContext: bg)
                            _ = Tag(name: TagConstants.favoriteTag, inContext: bg)
                            
                            books.forEach{ print($0) }
                            AppDelegate.model.save()
                        })
                        
                        self.loadDataToTableView()

                    }
                }catch{
                    usrDef.removeObject(forKey: AppDelegate.FirstLoadKey)
                    fatalError("Error while loading model")
                }
            }
            
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

