//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Seth Watson on 10/24/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import Foundation

// Holds a count of results returned from request and array of request objects
class ResultArray:Codable {
    var resultCount = 0
    var results = [SearchResult]()
}

class SearchResult:Codable, CustomStringConvertible {
    var artistName = ""
    var trackName = ""
    var kind = ""
    
    var description: String {
        return "Kind: \(kind) Name: \(name), Artist Name: \(artistName)\n"
    }
    
    
    
    var name:String {
        return trackName
    }
}
