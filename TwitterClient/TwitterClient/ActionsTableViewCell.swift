//
//  ActionsTableViewCell.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/15/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class ActionsTableViewCell: UITableViewCell {
    
    var associateTweet: Tweet?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAssociate(tweet: Tweet) {
        associateTweet = tweet
        self.sizeToFit()
    }
}
