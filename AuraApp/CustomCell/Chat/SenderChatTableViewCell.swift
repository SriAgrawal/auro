//
//  SenderChatTableViewCell.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 21/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class SenderChatTableViewCell: UITableViewCell {

    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var senderChatLabel: UILabel!
    @IBOutlet weak var senderChatView: UIView!
    @IBOutlet weak var senderImageView: UIImageView!
 
    @IBOutlet weak var chatwidthConstant: NSLayoutConstraint!
 
    override func awakeFromNib() {
        super.awakeFromNib()
       self.chatwidthConstant.constant = kWindowWidth - 140
        
        senderChatView.layer.shadowColor = UIColor.lightGray.cgColor
        senderChatView.layer.shadowOpacity = 0.3
        senderChatView.layer.shadowOffset = CGSize.zero
        senderChatView.layer.shadowRadius = 3
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
