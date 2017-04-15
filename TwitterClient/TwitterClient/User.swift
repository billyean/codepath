//
//  User.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/13/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    
    var screenName: String?
    
    var profileURL: URL?
    
    var tagline: String?
    
    var savedDictionary: NSDictionary
    
    init(dictionay: NSDictionary) {
        name = dictionay["name"] as? String
        screenName = dictionay["screen_name"] as? String
        
        if let profileURLStr = dictionay["profile_image_url_https"] as? String {
            profileURL = URL(string: profileURLStr)
        }
        tagline = dictionay["description"] as? String
        savedDictionary = dictionay
    }
}
