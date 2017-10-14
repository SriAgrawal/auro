//
//  CreateProfileTableViewCell.swift
//  AuraApp
//
//  Created by Sarvada Chauhan on 8/11/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class CreateProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var createProfileButton: UIButton!
    @IBOutlet weak var validationMessageLavel: UILabel!
    @IBOutlet weak var profileTextfield: CustomTextField!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
