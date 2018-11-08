//
//  ViewController.swift
//  StoreSearch
//
//  Created by Seth Watson on 10/24/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit

// Manages SearchBar and displaying list of SearchResult objects
class SearchViewController: UIViewController {
    private let search = Search()
    var landscapeVC: LandscapeViewController?
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        searchBar.becomeFirstResponder()
        
        // Add 108-point margin at the top - 20 points for the status bar and 44 points for the Search Bar
        tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
        
        // Register SearchResultCell nib for use
        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        
        // Register NothingFoundCell nib for use
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
        // Register LoadingCell nib for use
        cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
    }
    
    
    func showLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
        // 1 Prevent 2 landscape views showing simoltaneously, return if landscape is already present
        guard landscapeVC == nil else { return }
        // 2 Instntiate landscapeVC
        landscapeVC = storyboard!.instantiateViewController(withIdentifier: "LandscapeViewController") as? LandscapeViewController
        if let controller = landscapeVC {
            controller.search = search
            // 3 Define size & position of new landscapeVC, frame of landscapeVC must be equal to superview SearchViewController bounds
            controller.view.frame = view.bounds
            controller.view.alpha = 0
            // 4 Place new view on top, define new view as manager of the screen, tell new VC it has a parentVC
            view.addSubview(controller.view)
            addChild(controller)
            coordinator.animate(alongsideTransition: { _ in
                controller.view.alpha = 1
                self.searchBar.resignFirstResponder()
                if self.presentedViewController != nil {
                    self.dismiss(animated: true, completion: nil)
                }
            }, completion: { _ in
                controller.didMove(toParent: self)
            })
        }
    }
    
    func hideLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
        if let controller = landscapeVC {
            controller.willMove(toParent: nil)
            coordinator.animate(alongsideTransition: { _ in
                controller.view.alpha = 0
            }, completion: { _ in
                controller.view.removeFromSuperview()
                controller.removeFromParent()
                self.landscapeVC = nil
            })
        }
    }
    
    // Whenever a trait collection is modified willTransition updates UI
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        // Detects new rotation
        switch newCollection.verticalSizeClass {
        case .compact: showLandscape(with: coordinator)
        case .regular, .unspecified: hideLandscape(with: coordinator)
        }
    }
    
    
    //MARK: - Actions
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        performSearch()
    }
    
    
    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    //MARK: - TableViewCellIdentifiers
    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell = "LoadingCell"
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    // On click begin data request for search bar input
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
    
    func performSearch() {
        if let category = Search.Category(rawValue: segmentedControl.selectedSegmentIndex) {
            search.performSearch(for: searchBar.text!,category: category, completion: {  success in
                if !success {
                    self.showNetworkError()
                }
                self.tableView.reloadData()
                self.landscapeVC?.searchResultsReceived()
            })
            tableView.reloadData()
            searchBar.resignFirstResponder()
        }
    }
    
    // Allows the item to indicate its top position
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if case .results(let list) = search.state {
                let detailViewController = segue.destination as! DetailViewController
                let indexPath = sender as! IndexPath
                let searchResult = list[indexPath.row]
                detailViewController.searchResult = searchResult
            }
        }
    }
}


//MARK: - TableView Data Source
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch search.state {
        case .notSearchedYet:
            return 0
        case .loading:
            return 1
        case .noResults:
            return 1
        case .results(let list):
            return list.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch search.state {
        case .notSearchedYet:
            fatalError("Should never get here")
            
        case .loading:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TableViewCellIdentifiers.loadingCell,
                for: indexPath)
            
            let spinner = cell.viewWithTag(100) as!
            UIActivityIndicatorView
            spinner.startAnimating()
            return cell
            
        case .noResults:
            return tableView.dequeueReusableCell(
                withIdentifier: TableViewCellIdentifiers.nothingFoundCell,
                for: indexPath)
            
        case .results(let list):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TableViewCellIdentifiers.searchResultCell,
                for: indexPath) as! SearchResultCell
            
            let searchResult = list[indexPath.row]
            cell.configure(for: searchResult)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowDetail", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch search.state {
        case .notSearchedYet, .loading, .noResults:
            return nil
        case .results:
            return indexPath
        }
    }
    
    
    //    MARK: - Private Methods
    
    // Returns optional data object received from server
    func performStoreRequest(with url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Download Error: \(error.localizedDescription)")
            showNetworkError()
            return nil
        }
    }
    
    // Handle network request error
    func showNetworkError() {
        let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the iTunes Store." + " Please try again.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}






//// On click begin data request
//func performSearch() {
//    if !searchBar.text!.isEmpty {
//        searchBar.resignFirstResponder()
//        dataTask?.cancel()
//
//        isLoading = true
//        tableView.reloadData()
//        hasSearched = true
//        searchResults = []
//
//        // Create the URL object using the search text
//        let url = self.iTunesURL(searchText: searchBar.text!, category: segmentedControl.selectedSegmentIndex)
//        let session = URLSession.shared
//
//        // Create a data task using URLSession to fetch contents of the URL.
//        dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
//
//            // When a data task gets cancelled, its completion handler is still invoked but with an Error object that has error code -999
//            if let error = error as NSError?, error.code == -999 {
//                return //Search was cancelled
//            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
//
//                // Unwrap and parse data into SearchResult objects
//                if let data = data {
//                    self.searchResults = self.parse(data: data)
//                    self.searchResults.sort(by: <)
//
//                    // Dismiss LoadingCell, Reload tableView
//                    DispatchQueue.main.async {
//                        self.isLoading = false
//                        self.tableView.reloadData()
//                    }
//                    return
//                }
//            } else {
//                print("Failure \(response!)")
//            }
//            // Handle error
//            DispatchQueue.main.async {
//                self.hasSearched = false
//                self.isLoading = false
//                self.tableView.reloadData()
//                self.showNetworkError()
//            }
//        })
//        // Sends the request to the server on a background thread
//        dataTask?.resume()
//    }
//}
