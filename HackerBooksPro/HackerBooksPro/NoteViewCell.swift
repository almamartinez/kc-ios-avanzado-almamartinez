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
    
    var delegate: deleteNoteDelegate?
    
    
    @IBOutlet weak var textoNota: UILabel!
    @IBOutlet weak var imgNote: UIImageView!
    //MARK: - Bending the MVC
    // The view will directly observe the model
    // This is OK, when the view is highly specific as
    // in this case
    func startContent(note: Note, withDelegate: deleteNoteDelegate?){
        _note = note
        delegate = withDelegate
        syncWithNote()
        
    }
    
    func viewWillDisappear(){
            _noteObserver = nil
            _note = nil
    }


    @IBAction func deleteNote(_ sender: UIButton) {
        delegate?.performDeletion(ofNote: _note!)
        viewWillDisappear()
    }
    
    //MARK: - Lifecycle
    
    // Sets the view in a neutral state, before being reused
    override func prepareForReuse() {
        viewWillDisappear()
       // syncWithNote()
    }
    
    deinit {
        viewWillDisappear()
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
