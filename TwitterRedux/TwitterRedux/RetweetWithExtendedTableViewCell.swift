//
//  RetweetWithExtendedTableViewCell.swift
//  TwitterRedux
//
//  Created by Yan, Tristan on 4/22/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class RetweetWithExtendedTableViewCell: RetweetTableViewCell {

    @IBOutlet weak var extendedImageView: UIImageView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func setModel(model: Tweet, onViewController controller: UIViewController) {
        super.setModel(model: model, onViewController: controller)
        extendedImageView.setImageWith(model.extendedImageURL!)
    }
}
