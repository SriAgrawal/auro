//
//  CellicularTableViewCell.swift
//  AuraApp
//
//  Created by Sarvada Chauhan on 8/14/17.
//  Copyright © 2017 mobiloitte. All rights reserved.
//

import UIKit

class CellicularTableViewCell: UITableViewCell {
   
    @IBOutlet weak var TopBtnConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!

    @IBOutlet weak var photosButton: NotificationButton!
    @IBOutlet weak var mediaFileButton: NotificationButton!
    @IBOutlet weak var mobileDataLabel: UILabel!
    @IBOutlet weak var autoDownloadLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    @IBAction func photosBtnAction(_ sender: UIButton) {
        self.mediaFileButton.isSelected = false
        self.photosButton.isSelected = true
        
    }
    
    @IBAction func mediaFileBtnAction(_ sender: UIButton) {
        self.mediaFileButton.isSelected = true
        
        self.photosButton.isSelected = false
        
        
        
    }
}
