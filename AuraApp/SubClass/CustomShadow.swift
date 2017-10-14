//
//  CustomShadow.swift
//  AuraApp
//
//  Created by Sarvada Chauhan on 8/18/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class CustomShadow: UIView {
    
    override  public func layoutSubviews() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: -1 , height: 1)
        self.layer.shadowRadius = 11
        self.layer.shadowPath = UIBezierPath(rect: CGRect(x:0, y:0, width:UIScreen.main.bounds.width + 50, height:64)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }


}
