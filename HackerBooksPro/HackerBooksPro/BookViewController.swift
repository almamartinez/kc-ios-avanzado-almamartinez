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

    //MARK: - Init
    var _model : Book
    //let _delegate : DatasourceChangedDelegate
    
    init(model: Book){
        _model = model
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
                                            managedObjectContext: AppDelegate.model.context,
                                            sectionNameKeyPath: nil,
                                            cacheName: nil)
        let notesVC = AnnotationViewController(fetchedResultsController: fc as! NSFetchedResultsController<NSFetchRequestResult>, layout: UICollectionViewFlowLayout(), book: _model)
        
        navigationController?.pushViewController(notesVC, animated: true)
    }
    
    func changeFavourite()  {
        do{
            // Creamos el fetchRequest
            let fr = NSFetchRequest<Tag>(entityName: Tag.entityName)
            fr.fetchBatchSize = 50
            fr.predicate = NSPredicate(format: "name == %@", TagConstants.favoriteTag)
            
            
            let res = try AppDelegate.model.context.fetch(fr)
            var t : Tag
            if res.count>0{
                t = res[0]
                
            }else {
                t = Tag(name: TagConstants.favoriteTag, inContext: AppDelegate.model.context)
            }
            let bt = BookTag(book: _model, tag: t, inContext: AppDelegate.model.context)
            
            if !_model.isFavourite{
                _model.addToBookTags(bt)
                
            }else
            {
                let fr2 = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
                fr2.fetchBatchSize = 50
                fr2.predicate = NSPredicate(format: "SELF == %@", bt)
                
                let resBookTags = try AppDelegate.model.context.fetch(fr2)
                if resBookTags.count > 0 {
                    let fRes = resBookTags[0]
                    _model.removeFromBookTags(bt)
                    t.removeFromBooksTag(bt)
                    AppDelegate.model.context.delete(fRes)
                    AppDelegate.model.save()
                }
                
            }
            
        }catch let e as NSError{
            print("Error while trying to perform a search: \n\(e)")
        }
    }
    
    @IBAction func switchFavorite(_ sender: AnyObject) {
    
        self.changeFavourite()
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
            
            AppDelegate.model.save()
            //self._delegate.executeSearch()
            self.syncViewWithModel(book: book)
        }
    }
    
    func stopObserving(book:Book){
        
        _nc.removeObserver(bookObserver)
    }
    
}

extension BookViewController: LibraryViewControllerDelegate{
    
    func libraryViewController(_ sender: LibraryViewController,
                               didSelect selectedBook:Book){
        stopObserving(book: _model)
        _model = selectedBook
        
        startObserving(book: selectedBook)
        
    }
}


