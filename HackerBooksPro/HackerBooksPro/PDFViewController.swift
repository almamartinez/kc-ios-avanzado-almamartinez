//
//  PDFViewController.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 8/24/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController{
    
    var _model : Book?
    var _bookObserver : NSObjectProtocol?
    
    @IBOutlet weak var browserView: UIWebView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!

    
    init(model: Book){
        _model = model
        super.init(nibName: nil, bundle: nil)
        title = _model?.tittle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        browserView.delegate=self
        activityView.startAnimating()
        setupNotifications()

        browserView.load((_model?.pdf?.pdf)!, mimeType: "application/pdf", textEncodingName: "utf8", baseURL: URL(string:"https://www.google.com")!)
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tearDownNotifications()
    }
    
   
    
}

extension PDFViewController: UIWebViewDelegate{
    func webViewDidFinishLoad(_ webView: UIWebView){
        
        //Parar el activity view
        activityView.stopAnimating()
        
        // Ocultarlo
        activityView.isHidden = true
    }
}

//MARK: - Notifications
extension PDFViewController{
    
    func setupNotifications(){
        
       let nc = NotificationCenter.default
        _bookObserver = nc.addObserver(forName: AsyncPdfDataDidEndLoading, object: _model?.pdf, queue: nil){ (n: Notification) in
            
            self.browserView.load((self._model?.pdf?.pdf)!, mimeType: "application/pdf", textEncodingName: "utf8", baseURL: URL(string:"https://www.google.com")!)
            AppDelegate.model.save()
 
        }
    }
    
    func tearDownNotifications(){
        
        let nc = NotificationCenter.default
        nc.removeObserver(_bookObserver)
        _bookObserver = nil
    }
}
