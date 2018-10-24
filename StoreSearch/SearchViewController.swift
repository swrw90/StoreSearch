//
//  ViewController.swift
//  StoreSearch
//
//  Created by Seth Watson on 10/24/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    var searchResults = [String]()

    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add 64-point margin at the top - 20 points for the status bar and 44 points for the Search Bar
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
    }


    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
}

extension SearchViewController: UISearchBarDelegate {
    
    // Add fake data to table view
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchResults = []
        for i in 0...2 {
            searchResults.append(String(format: "Fake Result %d for '%@'", i, searchBar.text!))
        }
        tableView.reloadData()
    }
    
//    “Allows the item to indicate its top position
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchResultCell"
        
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        cell.textLabel!.text = searchResults[indexPath.row]
        return cell
    }
}
