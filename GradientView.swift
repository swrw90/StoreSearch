//
//  GradientView.swift
//  StoreSearch
//
//  Created by Seth Watson on 11/2/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {
    // Set background color to transparent
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    
    // Draw gradient on top of transparent background
    override func draw(_ rect: CGRect) {
        // 1st array represents two shades of black, 2nd array represents the percentages of where to place these colors in the gradient.
        let components: [CGFloat] = [ 0, 0, 0, 0.3, 0, 0, 0, 0.7 ]
        let locations: [CGFloat] = [ 0, 1 ]
        // 2 Create gradient object
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: locations, count: 2)
        // 3 Define how big this gradient object should be
        let x = bounds.midX
        let y = bounds.midY
        let centerPoint = CGPoint(x: x, y : y)
        let radius = max(x, y)
        // 4 Draws the gradient 
        let context = UIGraphicsGetCurrentContext()
        context?.drawRadialGradient(gradient!, startCenter: centerPoint, startRadius: 0, endCenter: centerPoint, endRadius: radius, options: .drawsAfterEndLocation)
    }
}
