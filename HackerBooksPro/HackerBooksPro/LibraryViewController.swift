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
    
}

// MARK: - DataSource
extension LibraryViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HackerBooksPro"
        registerNib()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookTableViewCell.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        
        
        // Averiguar el book:
        let x = fetchedResultsController?.object(at: indexPath) as! BookTag
        print(type(of: x))
        
        let book = x.book!
        
        
        // Crear la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.cellID,
                                                 for:indexPath) as! BookTableViewCell
       
        cell.startObserving(book: book)
        
        

        // Devolverla
        return cell
        
    }

    
    //MARK: - Cell registration
    private func registerNib(){
        
        let nib = UINib(nibName: "BookTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: BookTableViewCell.cellID)
    }
}

