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
    
    lazy var dimmingView = GradientView(frame: CGRect.zero)
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        containerView!.insertSubview(dimmingView, at: 0)
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
