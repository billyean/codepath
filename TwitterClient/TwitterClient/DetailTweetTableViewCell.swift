//
//  DetailTweetTableViewCell.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/15/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class DetailTweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetImage: UIImageView!
    
    @IBOutlet weak var tweetContent: UILabel!
    
    @IBOutlet weak var tweetOwner: UILabel!
    
    @IBOutlet weak var tweetOwnerScreenName: UILabel!
    
    @IBOutlet weak var tweetTime: UILabel!
    
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
        
        tweetContent.text = tweet.tweetMessage
        
        if let tweetImageURL = tweet.imageURL {
            tweetImage.setImageWith(tweetImageURL, placeholderImage: UIImage(named: "tweet"))
        }
        
        if let tweetName = tweet.name {
            tweetOwner.text = tweetName
        }
        
        if let tweetScreenName = tweet.screenName {
            tweetOwnerScreenName.text = tweetScreenName
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        tweetTime.text = dateFormatter.string(from: tweet.tweetedDate!)
    }

}
