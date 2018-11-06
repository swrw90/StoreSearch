//
//  Search.swift
//  StoreSearch
//
//  Created by Seth Watson on 11/6/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import Foundation

class Search {
    var searchResults: [SearchResult] = []
    var hasSearched = false
    var isLoading = false
    
    private var dataTask: URLSessionDataTask? = nil
    
    func performSearch(for text: String, category: Int) {
        print("Searching...")
    }
}
