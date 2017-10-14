//
//  BackUpTableViewCell.swift
//  AuraApp
//
//  Created by Sarvada Chauhan on 8/16/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class BackUpTableViewCell: UITableViewCell {

    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var backUpButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
