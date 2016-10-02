//
//  AnnotationsViewController.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 2/10/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AnnotationViewController: CoreDataCollectionViewController {
}

extension AnnotationViewController{
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Averiguar el book:
        let x = fetchedResultsController?.object(at: indexPath) as! Note
    
        // Crear la celda
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteViewCell.cellID, for: indexPath) as! NoteViewCell
        
        cell.startObserving(note: x)
        
        // Devolverla
        return cell

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        addNewNotebookButton()
    }
    

    //MARK: - Cell registration
    private func registerNib(){
        
        let nib = UINib(nibName: "NoteViewCell", bundle: Bundle.main)
        self.collectionView?.register(nib, forCellWithReuseIdentifier: NoteViewCell.cellID)
    }
    
    //MARK: - Utils
    func addNewNotebookButton(){
        
        let btn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
        
        navigationItem.rightBarButtonItem = btn
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Averiguar el book:
        let x = fetchedResultsController?.object(at: indexPath) as! Note
        
        goToNoteVC(note: x)
    }

    func addNewNote()  {
        //Crear una nota vacía
        let note = Note(book: self.refBook!, inContext: AppDelegate.model.context)
        goToNoteVC(note: note)
    }
    func goToNoteVC(note: Note) {
        let NoteVC = NoteViewController(model: note)
        navigationController?.pushViewController(NoteVC, animated: true)

    }

}
