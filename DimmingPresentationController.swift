//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Seth Watson on 10/31/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import Foundation
import UIKit

class DimmingPresentationController: UIPresentationController {
    

    
    override var shouldRemovePresentersView: Bool {
        return false
    }
}

extension DetailViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController( forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) ->
        UIPresentationController? {
            return DimmingPresentationController(
                presentedViewController: presented,
                presenting: presenting)
    }
}
