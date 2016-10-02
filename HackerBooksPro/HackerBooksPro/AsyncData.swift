//
//
//  AsyncData.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 7/12/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation
import UIKit
import CoreData

typealias AsyncData = NSManagedObject
    

//MARK: - Delegate
internal
protocol AsyncDataDelegate : class{
    
    func asyncData(_ sender: AsyncData, shouldStartLoadingFrom url: URL )->Bool
    func asyncData(_ sender: AsyncData, willStartLoadingFrom url: URL)
    func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL)
    func asyncData(_ sender: AsyncData, didFailLoadingFrom url: URL, error: NSError)
    func asyncData(_ sender: AsyncData, fileSystemDidFailAt url: URL, error: NSError)

    
}
// Default implemntation for infrequently used methods
extension AsyncDataDelegate {
    func asyncData(_ sender: AsyncData, shouldStartLoadingFrom url: URL )->Bool{
        return true
    }
    
    func asyncData(_ sender: AsyncData, willStartLoadingFrom url: URL){}
    
    func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL){}
    
    func asyncData(_ sender: AsyncData, didFailLoadingFrom url: URL, error: NSError){
        print("Error loading \(url).\n \(error)")
    }
    
    func asyncData(_ sender: AsyncData, fileSystemDidFailAt url: URL, error: NSError){
        print("Error at \(url).\n \(error)")
    }
    
    
}

/*
//MARK: - Notifications
let AsyncDataDidEndLoading = Notification.Name(rawValue: "io.keepCoding.AsyncDataDidEndLoading")

extension AsyncData{
    func sendNotification(){
        
        let n = Notification(name: AsyncDataDidEndLoading,
                             object: self, userInfo: ["url" : url, "data" : _data])
        
        let nc = NotificationCenter.default
        
        nc.post(n)
        
        i = i + 1
        print("Async \(url) --  \(i)")
    }
}


*/
























