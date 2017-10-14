//
//  RecieverChatImageTableViewCell.swift
//  AuraApp
//
//  Created by Krati Agarwal on 05/10/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class RecieverChatImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recieverProfileImageView: UIImageView!
    
    @IBOutlet weak var recieverSendedImageView: UIImageView!
    
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBOutlet weak var recieverShowPhotoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
