//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Seth Watson on 10/31/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit
import MessageUI

class DetailViewController: UIViewController {
    var downloadTask: URLSessionDownloadTask?
    var isPopUp = false
    var searchResult: SearchResult! {
        didSet {
            if isViewLoaded {
                updateUI()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        
        // PopUp View Styling
        view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
        popupView.layer.cornerRadius = 10

        if isPopUp {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
            gestureRecognizer.cancelsTouchesInView = false
            gestureRecognizer.delegate = self
            view.addGestureRecognizer(gestureRecognizer)
            
            view.backgroundColor = UIColor.clear
            
            // Hides the pop-up view until a SearchResult is selected in the table view
        } else {
            view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
            popupView.isHidden = true
        }
        
        if let displayName = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String {
            title = displayName
        }
        
        if searchResult != nil {
            updateUI()
        }
    }
    
    enum AnimationStyle {
        case slide
        case fade
    }
    
    var dismissStyle = AnimationStyle.fade
    
    //MARK: - Outlets
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    // MARK:- Actions
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
        dismissStyle = .slide 
    }
    
    @IBAction func openInStore() {
        if let url = URL(string: searchResult.storeURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK:- Helper Methods
    
    // Update popUpView content
    func updateUI() {
        nameLabel.text = searchResult.name
        
        if searchResult.artistName.isEmpty {
            artistNameLabel.text = NSLocalizedString("Unknown", comment: "Search Result: Unknown")
        } else {
            artistNameLabel.text = searchResult.artistName
        }
        
        kindLabel.text = searchResult.type
        genreLabel.text = searchResult.genre
        
        // Show price
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = searchResult.currency
        
        let priceText: String
        if searchResult.price == 0 {
            priceText = NSLocalizedString("Free", comment: "Result Price: Free")
        } else if let text = formatter.string(
            from: searchResult.price as NSNumber) {
            priceText = text
        } else {
            priceText = ""
        }
        
        priceButton.setTitle(priceText, for: .normal)
        
        // Get image
        if let largeURL = URL(string: searchResult.imageLarge) {
            downloadTask = artworkImageView.loadImage(url: largeURL)
        }
        
        popupView.isHidden = false
    }
    
    deinit {
        print("deinit \(self)")
        downloadTask?.cancel()
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMenu" {
            let controller = segue.destination as! MenuViewController
            controller.delegate = self
        }
    }
}


extension DetailViewController: UIGestureRecognizerDelegate {
    
    // Dismiss popUpView if pressed outside of popUpView
    func gestureRecognizer( _ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
    
    // Call bounceAnimationController for animation when popUpView is presented
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return BounceAnimationController()
    }
    // Calls slideOutAnimationController to animate popUpView dismiss
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch dismissStyle {
        case .slide:
            return SlideOutAnimationController()
        case .fade:
            return FadeOutAnimationController()
        }
    }
}

extension DetailViewController: MenuViewControllerDelegate {
    func menuViewControllerSendEmail(_: MenuViewController) {
        
    }
}
