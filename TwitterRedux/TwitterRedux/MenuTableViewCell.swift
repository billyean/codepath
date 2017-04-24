//
//  MenuTableViewCell.swift
//  TwitterRedux
//
//  Created by Yan, Tristan on 4/22/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuTitleLabel: UILabel!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTopConstraint(value: CGFloat) {
        topConstraint.constant = value
    }

}
