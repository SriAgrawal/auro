//
//  NavigationControllerExtensions.swift
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 01/06/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    func popWithFadeAnimation() {
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.view.layer.add(transition, forKey: nil)
        self.popViewController(animated: false)
    }
    
    func pushToViewControllerWithFadeAnimation(_ controller: UIViewController) {
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.view.layer.add(transition, forKey: nil)
        self.pushViewController(controller, animated: false)
    }
}
