//
//  CustomButton.swift
//  AuraApp
//
//  Created by Sarvada Chauhan on 8/11/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

           
    override public func layoutSubviews() {
        super.layoutSubviews()
        setTitleColor(.white, for: .normal)
        self.backgroundColor = UIColor.init(red: 57/255, green: 201/255, blue: 198/255, alpha: 1.0)
        self.layer.cornerRadius = self.frame.size.height / 2
    
    }

    }
    

