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
   
   let model = CoreDataStack.defaultStack(modelName: DATABASE)!
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
        
        let t = getFavoriteTag()!

        //Lo mismo para el libro:
        let bt = BookTag(book: book, tag: t, inContext: (fetchedResultsController?.managedObjectContext)!)
        //book.removeFromBookTags(bt)
        //t.removeFromBooksTag(bt)
        model.context.delete(bt)
        model.save()
        
        
    }
    
    func addBookToFavorites(book: Book){
        let t = getFavoriteTag()!
        
        //Lo mismo para el libro:
        let bt = BookTag(book: book, tag: t, inContext: (fetchedResultsController?.managedObjectContext)!)
        
        book.addToBookTags(bt)
        model.save()

    }
    
    func getFavoriteTag() -> Tag?{
        // Creamos el fetchRequest para sacar el Tag Favoritos
        let fr = NSFetchRequest<Tag>(entityName: Tag.entityName)
        fr.fetchBatchSize = 50
        fr.predicate = NSPredicate(format: "name == %@", TagConstants.favoriteTag)
        let t : Tag?
        do{
            let res = try model.context.fetch(fr)
            
            if res.count>0{
                t = res[0]
                
            }else {
                t = Tag(name: TagConstants.favoriteTag, inContext: model.context)
            }
            return t

        }catch let e as NSError{
            print("Error while Searching Favorite Tag: \n\(e)")
        }
        
        return nil
    }

}

//MARK: - Delegate protocol
protocol FavoritesDelegate {
    //func libraryViewController(_ sender: LibraryViewController, didSelect selectedBook:Book)
    func deleteBookFromFavorites(book:Book)
    func addBookToFavorites(book: Book)
    func getFavoriteTag() -> Tag?
}
