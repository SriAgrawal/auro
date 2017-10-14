//
//  ContactTableViewCell.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 12/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var chatButtonLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var chatButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var inviteButton: NotificationButton!
    @IBOutlet weak var contactView: UIView!

    @IBOutlet weak var contactNameTrailingConstant: NSLayoutConstraint!
    @IBOutlet weak var chatButton: NotificationButton!
    @IBOutlet weak var callButton: NotificationButton!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactTitleLabel: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    
    @IBOutlet weak var timeDateLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        contactView.layer.shadowColor = UIColor.lightGray.cgColor
        contactView.layer.shadowOpacity = 0.3
        contactView.layer.shadowOffset = CGSize.zero
        contactView.layer.shadowRadius = 3
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func callButtonAction(_ sender: UIButton) {
    }
    @IBAction func chatButtonAction(_ sender: UIButton) {
    }
}
