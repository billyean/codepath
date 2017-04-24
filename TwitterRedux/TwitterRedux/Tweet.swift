//
//  Tweet.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/11/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//


import UIKit

class Tweet: NSObject {
    var id: Int?
    
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
    
    var extended: Bool = false
    
    var extendedImageURL: URL?
    
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

            if timeInternal! < 7 {
                timeInternal?.round()
                let value = Int(timeInternal!)
                return "\(value)d"
            }
            
            if timeInternal! < 30 {
                var timeInternalw = timeInternal
                timeInternalw?.divide(by: 7)
                timeInternalw?.round()
                let value = Int(timeInternalw!)
                return "\(value)d"
            }
            
            if timeInternal! < 365 {
                var timeInternalh = timeInternal
                timeInternalh?.divide(by: 7)
                timeInternalh?.round()
                let value = Int(timeInternalh!)
                return "\(value)d"
            } else {
                timeInternal?.divide(by: 365)
            }

            timeInternal?.round()
            let value = Int(timeInternal!)
            return "\(value)y"
        }
    }
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as? Int
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
        
        if let entities = lookDictionary["entities"] as? NSDictionary {
            if let media = (entities["media"] as? [NSDictionary])?[0] {
                if let media_url_str = media["media_url_https"] {
                    extended = true
                    extendedImageURL = URL(string: media_url_str as! String)
                }
            }
        }
    }
}
