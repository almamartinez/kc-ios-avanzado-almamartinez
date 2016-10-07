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
    let searchController = UISearchController(searchResultsController: nil)
}

// MARK: -
extension LibraryViewController{
    //MARK: - Delegate & DataSource
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HackerBooksPro"
        registerNib()
        createSearchBar()
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // let x = fetchedResultsController?.object(at: indexPath) as! BookTag
        
        //x.managedObjectContext?.delete(x)
        //fetchedResultsController?.managedObjectContext.delete(x)
        
        // Get the book
        let book = getBook(atIndexPath: indexPath)
       // book.managedObjectContext?.delete(x)
        
        // Create the VC
        let bookVC = BookViewController(model: book, delegate:self)
        
        // Load it
        navigationController?.pushViewController(bookVC, animated: true)
 
    }
    
    // Mark: - Utils
    
    func getBook(atIndexPath : IndexPath) -> Book {
        // Averiguar el book:
        let x = fetchedResultsController?.object(at: atIndexPath) as! BookTag
        //print(type(of: x))
        
        return x.book!
    }

    
    //MARK: - Cell registration
    private func registerNib(){
        
        let nib = UINib(nibName: "BookTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: BookTableViewCell.cellID)
    }
    
    private func createSearchBar(){
        searchController.searchBar.placeholder = "Search..."
        searchController.searchBar.backgroundColor = UIColor.clear
        searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchController.searchBar.tintColor = UIColor.blue
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func fetchEntries(searchText: String) {
        
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        fr.fetchBatchSize = 50
        
        let sd = NSSortDescriptor(key: "tag.name", ascending: true)
        let sd2 = NSSortDescriptor(key: "book.tittle", ascending: true)
        fr.sortDescriptors = [sd, sd2]

       /* if (searchText.characters.count > 0 && searchText.characters.count <= 3){
            return
        }*/
        
        //if (searchText.characters.count > 3){
        if (searchText.characters.count > 0){
            
            let str = " LIKE '*".appending(searchText).appending("*'")
            
            let pred = NSPredicate(format: "book.tittle".appending(str) )
            let pred2 = NSPredicate(format: "tag.name".appending(str))
            let pred3 = NSPredicate(format: "ANY book.authors.name ".appending(str))
            
            let compPred = NSCompoundPredicate(orPredicateWithSubpredicates: [pred, pred2, pred3])
            
            fr.predicate = compPred

        }
        
       // print("texto de búsqueda:... \(searchText)")
        
                // Creamos el fetchedResultsCtrl
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fr as! NSFetchRequest<NSFetchRequestResult>,
                                            managedObjectContext: model.context,
                                            sectionNameKeyPath: "tag.name",
                                            cacheName: nil)

    }
    
}

extension LibraryViewController: FavoritesDelegate{
    func deleteBookFromFavorites(book:Book){
        
       
        
        let bt2 = book.bookTags?.first(where: { (bt) -> Bool in
            ((bt as! BookTag).name?.contains(TagConstants.favoriteTag))!
        })
        
        book.removeFromBookTags(bt2 as! BookTag)
        book.managedObjectContext!.delete(bt2 as! NSManagedObject)
        try! book.managedObjectContext!.save()        
        
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

extension LibraryViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        fetchEntries(searchText: searchBar.text!)
    }
}

extension LibraryViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        fetchEntries(searchText: searchController.searchBar.text!)
    }
}

//MARK: - Delegate protocol
protocol FavoritesDelegate {
        func deleteBookFromFavorites(book:Book)
    func addBookToFavorites(book: Book)
    func getFavoriteTag() -> Tag?
}
