//
//  Tweet.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/11/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//


import UIKit

class Tweet: NSObject {
    var tweetId: Int?
    
    var tweetMessage: String?
    
    var tweetedDate: Date?
    
    var imageURL: URL?
    
    var replyCount: Int
    
    var retweetCount: Int
    
    var favoritesCount: Int
    
    init(dictionary: NSDictionary) {
        tweetMessage = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        replyCount = (dictionary["reply_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorites_count"] as? Int) ?? 0
        
        if let timestamepStr = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            tweetedDate = formatter.date(from: timestamepStr)
        }
    }
}
