//
//  DetailRetweetTableViewCell.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/15/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class DetailRetweetTableViewCell: DetailTweetTableViewCell {
    
    @IBOutlet weak var retweetedBy: UILabel!
    
    override func setAssociate(tweet: Tweet) {
        super.setAssociate(tweet: tweet)
        retweetedBy.text = tweet.retweetedBy! + " Retweeted"
    }

}
