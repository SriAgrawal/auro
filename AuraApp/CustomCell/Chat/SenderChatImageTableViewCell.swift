//
//  SenderChatImageTableViewCell.swift
//  AuraApp
//
//  Created by Krati Agarwal on 05/10/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class SenderChatImageTableViewCell: UITableViewCell {

    @IBOutlet weak var senderProfileImageView: UIImageView!
    
    @IBOutlet weak var senderSendedImageView: UIImageView!
    
    @IBOutlet weak var senderShowPhotoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
