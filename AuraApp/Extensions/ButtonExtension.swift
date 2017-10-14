//
//  ButtonExtension.swift
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 01/06/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

import UIKit

extension UIButton {

    func underLine(state: UIControlState = .normal) {
        
        if let title = self.title(for: state) {
            
            let color = self.titleColor(for: state)

            let attrs = [
                NSForegroundColorAttributeName : color ?? UIColor.blue,
                NSUnderlineStyleAttributeName : 1] as [String : Any]
            
            let buttonTitleStr = NSMutableAttributedString(string:title, attributes:attrs)
            self.setAttributedTitle(buttonTitleStr, for: state)
        }
    }

}

