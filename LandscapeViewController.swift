//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Seth Watson on 11/3/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Remove constraints from main view
        view.removeConstraints(view.constraints)
        view.translatesAutoresizingMaskIntoConstraints = true
        // Remove constraints for page control
        pageControl.removeConstraints(pageControl.constraints)
        pageControl.translatesAutoresizingMaskIntoConstraints = true
        // Remove constraints for scroll view
        scrollView.removeConstraints(scrollView.constraints)
        scrollView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
