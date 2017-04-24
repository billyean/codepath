//
//  TweetTableViewCell.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/14/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class RetweetTableViewCell: TweetTableViewCell {
    @IBOutlet weak var retweetedByLabel: UILabel!
    
    override func setModel(model: Tweet, onViewController controller: UIViewController) {
        super.setModel(model: model, onViewController: controller)
        
        retweetedByLabel.text = "Retweeted by \((model.retweetedBy)!)"
    }
}
