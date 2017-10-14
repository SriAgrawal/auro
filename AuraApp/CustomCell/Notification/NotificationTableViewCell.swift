//
//  NotificationTableViewCell.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 14/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var activeTimeLabel: UILabel!
    @IBOutlet weak var rejectButton: NotificationButton!
    @IBOutlet weak var acceptButton: NotificationButton!
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

        
    }
    
}
