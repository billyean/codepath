//
//  TweetTableViewCell.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/14/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit
import AFNetworking

class RetweetTableViewCell: TweetTableViewCell {
    @IBOutlet weak var retweetedByLabel: UILabel!
    
    override func setAssociation(tweet: Tweet) {
        super.setAssociation(tweet: tweet)
        
        if let retweetedBy = tweet.retweetedBy {
            retweetedByLabel.text = "\(retweetedBy) Retweeted"
        }

    }
}
