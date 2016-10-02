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
        let bookVC = BookViewController(model: book)
        
        // Load it
        navigationController?.pushViewController(bookVC, animated: true)
    }

    
    //MARK: - Cell registration
    private func registerNib(){
        
        let nib = UINib(nibName: "BookTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: BookTableViewCell.cellID)
    }
    
    
}
//MARK: - Delegate protocol
protocol LibraryViewControllerDelegate {
    func libraryViewController(_ sender: LibraryViewController, didSelect selectedBook:Book)
}
