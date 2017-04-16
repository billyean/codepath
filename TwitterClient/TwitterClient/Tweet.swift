//
//  Tweet.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/11/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//


import UIKit

class Tweet: NSObject {
    var tweetId: String?
    
    var tweetMessage: String?
    
    var name: String?
    
    var screenName: String?
    
    var tweetedDate: Date?
    
    var imageURL: URL?
    
    var replyCount: Int?
    
    var retweetCount: Int?
    
    var favoritesCount: Int?
    
    var isRetweeted: Bool = false
    
    var retweetedBy: String?
    
    var retweetedByScreenName: String?
    
    var retweetedAlready: Bool = false
    
    var favoritedAlready: Bool = false
    
    var timeToNow: String {
        get {
            var timeInternal = tweetedDate?.timeIntervalSinceNow.negated()

            if timeInternal! < 60.0 {
                timeInternal?.round()
                let value = Int(timeInternal!)
                return "\(value)s"
            } else {
                timeInternal?.divide(by: 60)
            }
            
            if timeInternal! < 60.0 {
                timeInternal?.round()
                let value = Int(timeInternal!)
                return "\(value)m"
            } else {
                timeInternal?.divide(by: 60)
            }
            
            if timeInternal! < 24.0 {
                timeInternal?.round()
                let value = Int(timeInternal!)
                return "\(value)h"
            } else {
                timeInternal?.divide(by: 24)
            }

            timeInternal?.round()
            let value = Int(timeInternal!)
            return "\(value)d"
        }
    }
    
    init(dictionary: NSDictionary) {
        tweetId = dictionary["id_str"] as? String
        if let timestamepStr = dictionary["created_at"] as? String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            tweetedDate = formatter.date(from: timestamepStr)
        }

        if let retweetedStr = dictionary["retweeted"] {
            retweetedAlready = retweetedStr as! Bool
        }
        
        if let favoritedStr = dictionary["favorited"] {
            favoritedAlready = favoritedStr as! Bool
        }
        
        var lookDictionary = dictionary
        
        if let retweetDictionary = dictionary["retweeted_status"] as? NSDictionary {
            lookDictionary = retweetDictionary
            isRetweeted = true
            if let user = dictionary["user"] as? NSDictionary {
                retweetedBy = user["name"] as? String
                retweetedByScreenName = user["screen_name"] as? String
            }
        }
        
        tweetMessage = lookDictionary["text"] as? String
        retweetCount = (lookDictionary["retweet_count"] as? Int) ?? 0
        replyCount = (lookDictionary["reply_count"] as? Int) ?? 0
        favoritesCount = (lookDictionary["favorite_count"] as? Int) ?? 0
        
        if let user = lookDictionary["user"] as? NSDictionary {
            if let imageURLStr = user["profile_image_url_https"] as? String {
                imageURL = URL(string: imageURLStr)
            }
            name = user["name"] as? String
            screenName = user["screen_name"] as? String
        }
    }
}
