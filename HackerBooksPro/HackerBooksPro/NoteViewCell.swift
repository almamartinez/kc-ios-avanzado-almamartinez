//
//  NoteViewCell.swift
//  HackerBooksPro
//
//  Created by Alma Martinez on 2/10/16.
//  Copyright © 2016 Alma Martinez. All rights reserved.
//

import Foundation
import UIKit

class NoteViewCell: UICollectionViewCell {
    static let cellID = "NoteCollectionViewCellId"
    static let cellHeight = 400
    static let cellWidth = 400
    //MARK: - private interface
    private
    var _note : Note?
    
    private
    let _nc = NotificationCenter.default
    private
    var _noteObserver : NSObjectProtocol?
    
    
    @IBOutlet weak var imgNote: UIImageView!
    @IBOutlet weak var textoNota: UITextView!
    //MARK: - Bending the MVC
    // The view will directly observe the model
    // This is OK, when the view is highly specific as
    // in this case
    func startObserving(note: Note){
        _note = note
        _nc.addObserver(forName: AsyncDataDidEndLoading, object: _note, queue: nil) { (n: Notification) in
            AppDelegate.model.save()
            self.syncWithNote()
        }
        syncWithNote()
        
    }
    
    func stopObserving(){
        
        if let observer = _noteObserver{
            _nc.removeObserver(observer)
            _noteObserver = nil
            _note = nil
        }
        
    }
    @IBAction func deleteNote(_ sender: UIButton) {
        AppDelegate.model.context.delete(_note!)
        stopObserving()
    }
    
    //MARK: - Lifecycle
    
    // Sets the view in a neutral state, before being reused
    override func prepareForReuse() {
        stopObserving()
        syncWithNote()
    }
    
    deinit {
        stopObserving()
    }
    
    //MARK: - Utils
    private
    func syncWithNote(){
        
        UIView.transition(with: self.imgNote,
                          duration: 0.7,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.imgNote.image = self._note?.photo?.image
            }, completion: nil)
        
        textoNota.text = _note?.text
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
}
