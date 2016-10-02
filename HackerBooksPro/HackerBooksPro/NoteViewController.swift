//
//  NoteViewController.swift
//  Everpobre
//
//  Created by Fernando Rodríguez Romero on 9/13/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    
    var model : Note
    
    @IBOutlet weak var textView: UITextView!

    @IBAction func displayPhoto(_ sender: AnyObject) {
        
        let pVC = PhotoViewController(model: model)
        navigationController?.pushViewController(pVC, animated: true)
    }
    
    init(model: Note){
        
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncModelView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        syncViewModel()
    }
    
    
    func syncModelView(){
        textView.text = model.text
        
    }
    
    func syncViewModel(){
        model.text = textView.text
    }
}











