//
//  DBManager.swift
//  engmyan
//
//  Created by Win Than Htike on 9/4/17.
//  Copyright © 2017 Soe Minn Minn. All rights reserved.
//

import UIKit
import FMDB

class DBManager: NSObject {
    
    var pathToDatabase: String!
    var database: FMDatabase!
    static let shared: DBManager = DBManager()
    
    
    override init() {
        super.init()
        pathToDatabase = prepareDatabaseFile()
    }
    
    func prepareDatabaseFile() -> String {
        
        let fileName: String = "EMDictionary.db"
        
        let fileManager:FileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let documentUrl = directory.appendingPathComponent(fileName)
        let bundleUrl = Bundle.main.resourceURL?.appendingPathComponent(fileName)
        
        // here check if file already exists on simulator
        if fileManager.fileExists(atPath: (documentUrl.path)) {
            print("document file exists!")
            return documentUrl.path
            
        } else if fileManager.fileExists(atPath: (bundleUrl?.path)!) {
            print("document file does not exist, copy from bundle!")
            
            do {
                try fileManager.copyItem(at:bundleUrl!, to:documentUrl)
            } catch _ {
                print("Can't Copy Item")
            }
        }
        
        return documentUrl.path
    }
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    func querySuggestWord() -> [DictionaryItem]! {
        
        var rows : [DictionaryItem]! = [DictionaryItem]()
        
        if openDatabase(){
            
            let query = "SELECT `_id`, `word`, `stripword` FROM `dictionary` ORDER BY `stripword` ASC LIMIT 20"
            
            do {
                let results = try database.executeQuery(query, values: nil)
                while results.next() {
                    let item = DictionaryItem(resultSet: results)
                    rows.append(item)
                }
                results.close()
                
            }catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return rows
    }
    
    func queryWord(constraint : String) -> [DictionaryItem]! {
        
        var rows : [DictionaryItem]! = [DictionaryItem]()
        var searchword : String = ""
        
        if openDatabase(){
            searchword = searchword.replacingOccurrences(of: "'", with: "''").replacingOccurrences(of: "_", with: "")
            if (constraint.contains("?")) || (constraint.contains("*")) {
                searchword = constraint.replacingOccurrences(of: "?", with: "_")
                searchword = constraint.replacingOccurrences(of: "*", with: "%")
            } else {
                searchword = constraint + "%"
            }
            
            let query = "SELECT `_id`, `word`, `stripword` FROM `dictionary` WHERE `word` LIKE '\(searchword)' ORDER BY `stripword` ASC"
            
            do {
                let results = try database.executeQuery(query, values: nil)
                while results.next() {
                    let item = DictionaryItem(resultSet: results)
                    rows.append(item)
                }
                results.close()
                
            }catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return rows
    }
    
    func queryDefinition(id: Int) -> DictionaryItem! {
        var row : DictionaryItem!
        
        if openDatabase() {
            let query = "SELECT `_id`, `word`, `stripword`, `title`, `definition`, `keywords`, `synonym`, `filename`, `picture`, `sound` " +
                "FROM `dictionary` WHERE `_id` IS '\(id)';"
            
            do {
                let results = try database.executeQuery(query, values: nil)
                if results.next() {
                    row = DictionaryItem(resultSet: results)
                }
                results.close()
                
            } catch {
                print(error.localizedDescription)
            }
            
            database.close()
        }
        return row
    }
    
}
