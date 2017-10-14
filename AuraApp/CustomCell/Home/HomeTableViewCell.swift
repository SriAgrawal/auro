//
//  HomeTableViewCell.swift
//  AuraApp
//
//  Created by Sunil Datt Joshi on 16/08/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var activeTimeLabel: UILabel!
    @IBOutlet weak var postPhotoImageView: UIImageView!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var friendsStatus: UILabel!
    @IBOutlet weak var friendsNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
   
    @IBOutlet weak var showPhotoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        homeView.layer.shadowColor = UIColor.lightGray.cgColor
        homeView.layer.shadowOpacity = 0.3
        homeView.layer.shadowOffset = CGSize.zero
        homeView.layer.shadowRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
