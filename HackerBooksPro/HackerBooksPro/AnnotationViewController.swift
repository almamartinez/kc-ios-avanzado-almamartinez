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
    let db = CoreDataStack.defaultStack(modelName: DATABASE)!
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
        let note = Note(book: self.refBook!, inContext: db.context)
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

extension AnnotationViewController: actionsOnNotesDelegate{
    internal func performDeletion(ofNote: Note) {
        db.context.delete(ofNote)
        db.save()
    }

    func share(note: Note){
        //Crear un uiActivityController
        let avc = UIActivityViewController(activityItems: arrayOfItems(fromNote: note), applicationActivities: nil)
        
        // lo presentamos
        self.present(avc, animated: true, completion: nil)
        
    }
    
    func arrayOfItems(fromNote note:Note) -> [AnyObject] {
        var arr = [AnyObject]()
        
        // El título del libro es obligatorio
        arr.append(note.book?.tittle as AnyObject)
        
        if let txt = note.text{
            arr.append(txt as AnyObject)
        }
        
        if let img = note.photo?.image{
            arr.append(img as AnyObject)
        }
        
        return arr as [AnyObject]
    }
}

protocol actionsOnNotesDelegate {
    func performDeletion(ofNote: Note)
    func share(note: Note)
}
