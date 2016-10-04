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
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 10.0, bottom: 50.0, right: 10.0)
    fileprivate let itemsPerRow: CGFloat = 2
}

extension AnnotationViewController{
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Averiguar el book:
        let x = fetchedResultsController?.object(at: indexPath) as! Note
    
        // Crear la celda
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteViewCell.cellID, for: indexPath) as! NoteViewCell
        
        cell.startContent(note: x,withDelegate: self)
        
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

extension AnnotationViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension AnnotationViewController: deleteNoteDelegate{
    internal func performDeletion(ofNote: Note) {
        AppDelegate.model.context.delete(ofNote)
        AppDelegate.model.save()
    }

    
}

protocol deleteNoteDelegate {
    func performDeletion(ofNote: Note)
}
