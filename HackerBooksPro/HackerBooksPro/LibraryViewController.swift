//
//  LibraryViewController.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 25/9/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import UIKit
import CoreData

class LibraryViewController: CoreDataTableViewController{
   // var delegate : LibraryViewControllerDelegate?
}

// MARK: - DataSource
extension LibraryViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title = "HackerBooksPro"
        registerNib()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookTableViewCell.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        let book = getBook(atIndexPath: indexPath)
        
        // Crear la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.cellID,
                                                 for:indexPath) as! BookTableViewCell
       
        cell.startObserving(book: book)
        

        // Devolverla
        return cell
        
    }
    
    func getBook(atIndexPath : IndexPath) -> Book {
        // Averiguar el book:
        let x = fetchedResultsController?.object(at: atIndexPath) as! BookTag
        //print(type(of: x))
        
        return x.book!
    }
    
    //MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Get the book
        let book = getBook(atIndexPath: indexPath)
        
        // Create the VC
        let bookVC = BookViewController(model: book, delegate:self)
        
        // Load it
        navigationController?.pushViewController(bookVC, animated: true)
    }

    
    //MARK: - Cell registration
    private func registerNib(){
        
        let nib = UINib(nibName: "BookTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: BookTableViewCell.cellID)
    }
    
    
}

extension LibraryViewController: FavoritesDelegate{
    func deleteBookFromFavorites(book:Book){
        do{
            // Creamos el fetchRequest para sacar el Tag Favoritos
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

            //Lo mismo para el libro: 
            let bt = BookTag(book: book, tag: t, inContext: (fetchedResultsController?.managedObjectContext)!)
            let fr2 = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
            fr2.fetchBatchSize = 50
            fr2.predicate = NSPredicate(format: "SELF == %@", bt)
            
            let resBookTags = try AppDelegate.model.context.fetch(fr2)
            if resBookTags.count > 0 {
                let fRes = resBookTags[0]
                book.removeFromBookTags(bt)
                t.removeFromBooksTag(bt)
                fetchedResultsController?.managedObjectContext.delete(fRes)
                AppDelegate.model.save()
            }
            
        }catch let e as NSError{
            print("Error while trying to perform a search: \n\(e)")
        }
    }
}

//MARK: - Delegate protocol
protocol FavoritesDelegate {
    //func libraryViewController(_ sender: LibraryViewController, didSelect selectedBook:Book)
    func deleteBookFromFavorites(book:Book)
}
