//
//  ViewController.swift
//  StoreSearch
//
//  Created by Seth Watson on 10/24/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    var searchResults = [SearchResult]()
    var hasSearched = false

    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        
        // Add 64-point margin at the top - 20 points for the status bar and 44 points for the Search Bar
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        // Register SearchResultCell nib for use
        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        
        // Register NothingFoundCell nib for use
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
    }


    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - TableViewCellIdentifiers
    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "nothingFoundCell"
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    // Add fake data to table view
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchResults = []
        
//        Create an instance of the SearchResult object && add fake text into its properties
        if searchBar.text! != "justin bieber" {
        for i in 0...2 {
            let searchResult = SearchResult()
            searchResult.name = String(format: "Fake Result %d for", i)
            searchResult.artistName = searchBar.text!
            searchResults.append(searchResult)
        }
        }
        hasSearched = true
        tableView.reloadData()
    }
    
//    “Allows the item to indicate its top position
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
        if searchResults.count == 0 {
            cell.nameLabel.text = "(Nothing found)"
            cell.artistNameLabel.text = ""
        } else {
            let searchResult = searchResults[indexPath.row]
            cell.nameLabel.text = searchResult.name
            cell.artistNameLabel.text = searchResult.artistName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }
}
