//
//  MyProfileTableViewCell.swift
//  AuraApp
//
//  Created by Sarvada Chauhan on 8/17/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class MyProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var editProfileClick: UIButton!
    @IBOutlet weak var profileNameTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
 
}
