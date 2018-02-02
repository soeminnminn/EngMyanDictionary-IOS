//
//  DictionaryItem.swift
//  engmyan
//
//  Created by New Wave Technology on 1/9/18.
//  Copyright © 2018 Soe Minn Minn. All rights reserved.
//
import UIKit
import FMDB

class DictionaryItem: NSObject {
    var id : Int = 0
    var word : String = ""
    var stripWord : String = ""
    var title : String = ""
    var definition : String = ""
    var keywords : String = ""
    var synonym : String = ""
    var filename : String = ""
    var picture : Bool = false
    var sound : Bool = false
    
    init(resultSet: FMResultSet) {
        id = resultSet.long(forColumn: "_id")
        word = resultSet.string(forColumn: "word")
        stripWord = resultSet.string(forColumn: "stripword")
        
        if resultSet.columnCount() > 3 {
            if let tmp = resultSet.string(forColumn: "title") {
                title = tmp
            }
            if let tmp = resultSet.string(forColumn: "definition") {
                definition = tmp
            }
            if let tmp = resultSet.string(forColumn: "keywords") {
                keywords = tmp
            }
            if let tmp = resultSet.string(forColumn: "synonym") {
                synonym = tmp
            }
            if let tmp = resultSet.string(forColumn: "filename") {
                filename = tmp
            }
            
            picture = resultSet.int(forColumn: "picture") == 1
            sound = resultSet.int(forColumn: "sound") == 1
        }
    }
}
