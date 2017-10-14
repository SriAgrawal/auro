//
//  RecieverChatTableViewCell.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 21/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class RecieverChatTableViewCell: UITableViewCell {

    @IBOutlet weak var recieverChatWidthConstant: NSLayoutConstraint!
    
    @IBOutlet weak var recieverImageView: UIImageView!
    
    @IBOutlet weak var recieverNameLabel: UILabel!
    @IBOutlet weak var recieverChatLabel: UILabel!
    @IBOutlet weak var recieverChatView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    self.recieverChatWidthConstant.constant = kWindowWidth - 140
        recieverChatView.layer.shadowColor = UIColor.lightGray.cgColor
        recieverChatView.layer.shadowOpacity = 0.3
        recieverChatView.layer.shadowOffset = CGSize.zero
        recieverChatView.layer.shadowRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
