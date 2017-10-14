//
//  NotificationLableTableViewCell.swift
//  AuraApp
//
//  Created by Krati Agarwal on 09/10/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class NotificationLableTableViewCell: UITableViewCell {
    
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var activeTimeLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var contactmageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        notificationView.layer.shadowColor = UIColor.lightGray.cgColor
        notificationView.layer.shadowOpacity = 0.3
        notificationView.layer.shadowOffset = CGSize.zero
        notificationView.layer.shadowRadius = 3

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
