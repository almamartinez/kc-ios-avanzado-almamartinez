//
//  BookViewController.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 8/21/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit
import CoreData


class BookViewController: UIViewController {

    //let db = CoreDataStack.defaultStack(modelName: DATABASE)!
    let db : NSManagedObjectContext
    //MARK: - Init
    var _model : Book
    let _delegate : FavoritesDelegate
    
    init(model: Book, delegate: FavoritesDelegate){
        _model = model
        db = _model.managedObjectContext!
        _delegate = delegate
       // _delegate = withDelegate
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Outlets
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var favoriteItem: UIBarButtonItem!
    
    //MARK: - Actions
    @IBAction func readBook(_ sender: AnyObject) {
        
        let pVC = PDFViewController(model: _model)
        navigationController?.pushViewController(pVC, animated: true)
        
    }
    
    @IBAction func doAnnotations(_ sender: UIBarButtonItem) {
        // Creamos el fetchRequest
        let fr = NSFetchRequest<Note>(entityName: Note.entityName)
        fr.fetchBatchSize = 50
        
        let sd = NSSortDescriptor(key: "modificationDate", ascending: true)
        fr.predicate = NSPredicate(format: "book = %@", self._model)
        
        
        fr.sortDescriptors = [sd]
        
        // Creamos el fetchedResultsCtrl
        let fc = NSFetchedResultsController(fetchRequest: fr,
                                            managedObjectContext: db,
                                            sectionNameKeyPath: nil,
                                            cacheName: nil)
        let notesVC = AnnotationViewController(fetchedResultsController: fc as! NSFetchedResultsController<NSFetchRequestResult>, layout: UICollectionViewFlowLayout(), book: _model)
        
        navigationController?.pushViewController(notesVC, animated: true)
    }
    
        
    @IBAction func switchFavorite(_ sender: AnyObject) {
    
        if !_model.isFavourite{
            _delegate.addBookToFavorites(book: _model)
            
        }else
        {
            _delegate.deleteBookFromFavorites(book: _model)
        }

        _model.isFavourite = !_model.isFavourite
    }
    //MARK: - Syncing
    func syncViewWithModel(book: Book){
        
        coverView.image = _model.bookCover?.image!
        title = _model.tittle
        if _model.isFavourite{
            favoriteItem.title = "★"
        }else{
            favoriteItem.title = "☆"
        }
        title = _model.tittle
        
    }
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        startObserving(book: _model)
        syncViewWithModel(book: _model)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObserving(book: _model)
    }
    
    
    //MARK: - Notifications
    let _nc = NotificationCenter.default
    var bookObserver : NSObjectProtocol?
    
    func startObserving(book: Book){
        // guardamos el libro en userDefaults, para la próxima vez que entremos
        let usrDef = UserDefaults()
        let objData = Utils.archiveURIRepresentation(ofAnObject: _model)
        usrDef.set(objData, forKey: AppDelegate.LastBookVisitedKey)
        bookObserver = _nc.addObserver(forName: BookDidChange, object: book, queue: nil){ (n: Notification) in
            
            try! self.db.save()
            self.syncViewWithModel(book: book)
        }
    }
    
    func stopObserving(book:Book){
        
        _nc.removeObserver(bookObserver)
    }
    
}



