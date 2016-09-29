//
//  JSONProcessing.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 8/19/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit
import CoreData
/*
 {
 "authors": "Scott Chacon, Ben Straub",
 "image_url": "http://hackershelf.com/media/cache/b4/24/b42409de128aa7f1c9abbbfa549914de.jpg",
 "pdf_url": "https://progit2.s3.amazonaws.com/en/2015-03-06-439c2/progit-en.376.pdf",
 "tags": "version control, git",
 "title": "Pro Git"
 }
*/

//MARK: - Errors
enum JSONErrors : Error{
    case missingField(name:String)
    case incorrectValue(name: String, value: String)
    case emptyJSONObject
    case emptyJSONArray
}


//MARK: - Aliases
typealias JSONObject    = String    // We'll only receive strings
typealias JSONDictionary = [String : JSONObject]
typealias JSONArray = [JSONDictionary]

//MARK: - Decodification
func decode(book dict: JSONDictionary, bgContext: NSManagedObjectContext) throws -> Book{
    
   // validate first
    try validate(dictionary: dict)
    
    // extract from dict
    func extract(key: String) -> String{
        return dict[key]!   // we know it can't be missing because we validated first!
    }
    
    // parsing
    let authors = parseCommaSeparated(string: extract(key: "authors"))
    let imgURL = extract(key: "image_url")
    let pdfURL = extract(key: "pdf_url")
    let title = extract(key: "title").capitalized
    
    let book = Book(title: title, authors: authors, urlCover: imgURL, urlPdf: pdfURL, inContext: bgContext)
    
    let tagsStr = parseCommaSeparated(string: extract(key: "tags"))
    let req = NSFetchRequest<Tag>(entityName: Tag.entityName)
    for t in tagsStr {
        let predicate = NSPredicate(format: "name== %@",t)
        req.predicate = predicate
        var tag : Tag
        do{
            let fetchedTags = try bgContext.fetch(req)
            if (fetchedTags.count == 0){
                tag = Tag(name: t, inContext: bgContext)
            }else{
               tag = fetchedTags[0]
            }
            
            
        }catch{
            tag = Tag(name: t, inContext: bgContext)
        }
        
        let bt = BookTag(book: book, tag: tag, inContext: bgContext)
        
        tag.addToBooksTag(bt)
        book.addToBookTags(bt)
    }
    try! bgContext.save()
   return book
    
    
    
    
    //let mainBundle = Bundle.main
    
    //let defaultImage = mainBundle.url(forResource: "emptyBookCover", withExtension: "png")!
    //let defaultPdf = mainBundle.url(forResource: "emptyPdf", withExtension: "pdf")!
    
    // AsyncData
    // let image = AsyncData(url: imgURL, defaultData: try! Data(contentsOf: defaultImage))
    //let pdf = AsyncData(url: pdfURL, defaultData: try! Data(contentsOf: defaultPdf))
    
    //return Book(title: title, authors: authors, tags: tags, pdf: pdf, image: image)
    
}

func decode(book dict: JSONDictionary?, bgContext: NSManagedObjectContext) throws -> Book{
    
    guard let d = dict else {
        throw JSONErrors.emptyJSONObject
    }
    return try decode(book:d, bgContext: bgContext)
}

func decode(books dicts: JSONArray, bgContext: NSManagedObjectContext) throws -> [Book]{
    
    return try dicts.flatMap{
        try decode(book:$0, bgContext : bgContext)
    }
}

func decode(books dicts: JSONArray?, bgContext: NSManagedObjectContext) throws -> [Book]{
    guard let ds = dicts else {
        throw JSONErrors.emptyJSONArray
    }
    return try decode(books: ds, bgContext : bgContext)
}



//MARK: - Validation
// Validation should be kept waya from processing to
// insure the single responsability principle
// https://medium.com/swift-programming/why-swift-guard-should-be-avoided-484cfc2603c5#.bd8d7ad91
private
func validate(dictionary dict: JSONDictionary) throws{
    
    func isMissing() throws{
        for key in dict.keys{
            guard let value = dict[key] else{
                throw JSONErrors.missingField(name: key)
            }
            guard value.characters.count > 0  else {
                throw JSONErrors.incorrectValue(name: key, value: value)
            }
        }
        
    }
    
    try isMissing()
    
}


//MARK: - Parsing
func parseCommaSeparated(string s: String)->[String]{
    
    return s.components(separatedBy: ",").map({ $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }).filter({ $0.characters.count > 0})
}

