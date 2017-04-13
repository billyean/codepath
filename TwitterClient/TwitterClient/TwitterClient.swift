//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/12/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient()
    
    let apiKey = "k91BQyPLGLNNu3EJRorA7IL8J"
    
    let apiSecret = "3h5SOLBdyhxiQ252HMtdwHSH7Admg3ZkiRrfxSoverns5YJUec"
    
    let twitterBaseURLStr = "https://api.twitter.com/"
    
    let requestTokenURL = "oauth/request_token"
    
    let authURL = "oauth/authorize"
    
    let accessTokenURL = "oauth/access_token"
    
    var savedUser: String?
    
    private init () {
        super.init(baseURL: URL(string: twitterBaseURLStr), consumerKey: apiKey, consumerSecret: apiSecret)
        savedUser = UserDefaults.standard.string(forKey: "com.haiboyan.TwitterClient.username")
    }
    
    override private init(baseURL url: URL?, sessionConfiguration configuration: URLSessionConfiguration?) {
        super.init(baseURL: url, sessionConfiguration: configuration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func login(username: String, withPassword password: String) -> Bool {
        fetchRequestToken(withPath: requestTokenURL, method: "GET", callbackURL: URL(string: "tritterclient://oauth"), scope: nil, success: {
            (token) in
            UIApplication.shared.open(URL(string: "\(self.twitterBaseURLStr)\(self.authURL)")!, options: [String: Any](), completionHandler: {(success) in
                print("\(success)")
            })
        }, failure: {
            (error) in
            print("\(error)")
        })
        return false
    }
}
