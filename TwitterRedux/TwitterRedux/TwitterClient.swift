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
    
    let clientCallback = "twitterclient://oauth"
    
    let verifyCredentialURL = "1.1/account/verify_credentials.json"
    
    let homeTimelineURL = "1.1/statuses/home_timeline.json"
    
    let userTimelineURL = "1.1/statuses/user_timeline.json"
    
    let mentionsTimelineURL = "1.1/statuses/mentions_timeline.json"
    
    let newTweetURL = "1.1/statuses/update.json"
    
    let retweetURL = "1.1/statuses/retweet/tweetId.json"
    
    let unretweetURL = "1.1/statuses/unretweet/tweetId.json"
    
    let favoriteURL = "1.1/favorites/create.json"
    
    let unfavoriteURL = "1.1/favorites/destroy.json"
    
    var credential: BDBOAuth1Credential?
    
    var oauthToken: String?
    
    var loginSucess: ((User) -> Void)?
    
    var loginFailed: ((String) -> Void)?
    
    private init() {
        super.init(baseURL: URL(string: twitterBaseURLStr), consumerKey: apiKey, consumerSecret: apiSecret)
    }
    
    override private init(baseURL url: URL?, sessionConfiguration configuration: URLSessionConfiguration?) {
        super.init(baseURL: url, sessionConfiguration: URLSessionConfiguration.ephemeral)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func login(whenSucceeded succeededAction: ((User) -> Void)?, whenFailed failedAction: @escaping (String) -> Void) {
        loginSucess = succeededAction
        loginFailed = failedAction
        
        deauthorize()
        fetchRequestToken(withPath: requestTokenURL, method: "GET", callbackURL: URL(string: "twitterredux://oauth"), scope: nil, success: {
            (token) in
            if let oauthToken = token {
                let authorizeFullUrl = "\(self.twitterBaseURLStr)\(self.authURL)?force_login=1&oauth_token=\((oauthToken.token)!)"
                if let authrozieURL = URL(string: authorizeFullUrl) {
                    UIApplication.shared.open(authrozieURL, completionHandler: {(succeeded) in
                        if !succeeded {
                            failedAction("Failed to authenticate to Twitter")
                        } else {
                            print("Authenticate passed")
                        }
                    })
                } else {
                    failedAction("Internal error, invalid URL")
                }
            } else {
                failedAction("Return an empty token")
            }
        }, failure: { (error) in
            failedAction((error?.localizedDescription)!)
        })
    }
    
    func accessUserToken(queryString: String) {
        let credential = BDBOAuth1Credential(queryString: queryString)
        fetchAccessToken(withPath: accessTokenURL, method: "POST", requestToken: credential, success: { (userCredential) in
            if userCredential != nil {
                self.credential = userCredential
                self.verifyCredential(whenSucceeded: self.loginSucess, whenFailed: self.loginFailed)
            } else {
                if let loginFailed = self.loginFailed {
                    loginFailed("Verification failed")
                }
            }
        }) { (error) in
            if let loginFailed = self.loginFailed {
                loginFailed((error?.localizedDescription)!)
            }
        }
    }
    
    func verifyCredential(whenSucceeded succeededAction: ((User) -> Void)?, whenFailed failedAction: ((String) -> Void)?) {
        self.get(verifyCredentialURL, parameters: nil, success: { (task, response) in
            let userDictionary = response as! [String: Any]
            let currentUser = User(dictionay: userDictionary)
            currentUser.setCredential( userCredential: self.credential!)
            
            if let succeededAction = succeededAction {
                succeededAction(currentUser)
            }
        }, failure: { (task, error) in
            if let failedAction = failedAction {
                failedAction((error.localizedDescription))
            }
        })
    }
    
    func logout() {
        deauthorize()
    }
    
    func fetchTimeline(whenSucceeded succeededAction: @escaping ([Tweet]) -> Void, whenFailed failedAction: ((String) -> Void)?) {
        var parameters = [String:String]()
        parameters["exclude_replies"] = "0"
        self.get(homeTimelineURL, parameters: parameters, success: { (task, response) in
            if let tweetDictionaries = response as? [NSDictionary] {
                let  tweets = tweetDictionaries.map{ return Tweet(dictionary:$0)}
                succeededAction(tweets)
            }
        }, failure: { (task, error) in
            if let failedAction = failedAction {
                failedAction((error.localizedDescription))
            }
        })
    }
    
    func fetchMoreTimeline(oldestId: Int, whenSucceeded succeededAction: @escaping ([Tweet]) -> Void, whenFailed failedAction: ((String) -> Void)?) {
        var parameters = [String:String]()
        parameters["exclude_replies"] = "0"
        parameters["since_id"] = "\(oldestId)"
        print("since_id = \(oldestId)")
        self.get(homeTimelineURL, parameters: parameters, success: { (task, response) in
            if let tweetDictionaries = response as? [NSDictionary] {
                let  tweets = tweetDictionaries.map{ return Tweet(dictionary:$0)}
                succeededAction(tweets)
            }
        }, failure: { (task, error) in
            if let failedAction = failedAction {
                failedAction((error.localizedDescription))
            }
        })
    }
    
    func fetchUserTimeline(whenSucceeded succeededAction: @escaping ([Tweet]) -> Void, whenFailed failedAction: ((String) -> Void)?) {
        var parameters = [String:String]()
        parameters["exclude_replies"] = "0"
        parameters["user_id"] = User.sharedUserGroup.activeUser?.id
        self.get(userTimelineURL, parameters: parameters, success: { (task, response) in
            if let tweetDictionaries = response as? [NSDictionary] {
                let  tweets = tweetDictionaries.map{ return Tweet(dictionary:$0)}
                succeededAction(tweets)
            }
        }, failure: { (task, error) in
            if let failedAction = failedAction {
                failedAction((error.localizedDescription))
            }
        })
    }
    
    func fetchMoreUserTimeline(oldestId: Int, whenSucceeded succeededAction: @escaping ([Tweet]) -> Void, whenFailed failedAction: ((String) -> Void)?) {
        var parameters = [String:String]()
        parameters["exclude_replies"] = "0"
        parameters["user_id"] = User.sharedUserGroup.activeUser?.id
        parameters["since_id"] = "\(oldestId)"
        print("since_id = \(oldestId)")
        self.get(userTimelineURL, parameters: parameters, success: { (task, response) in
            if let tweetDictionaries = response as? [NSDictionary] {
                let  tweets = tweetDictionaries.map{ return Tweet(dictionary:$0)}
                succeededAction(tweets)
            }
        }, failure: { (task, error) in
            if let failedAction = failedAction {
                failedAction((error.localizedDescription))
            }
        })
    }
    
    func fetchMentionsTimeline(whenSucceeded succeededAction: @escaping ([Tweet]) -> Void, whenFailed failedAction: ((String) -> Void)?) {
        let parameters = [String:String]()
        self.get(mentionsTimelineURL, parameters: parameters, success: { (task, response) in
            if let tweetDictionaries = response as? [NSDictionary] {
                let  tweets = tweetDictionaries.map{ return Tweet(dictionary:$0)}
                succeededAction(tweets)
            }
        }, failure: { (task, error) in
            if let failedAction = failedAction {
                failedAction((error.localizedDescription))
            }
        })
    }
    
    func fetchMoreMentionsTimeline(oldestId: Int, whenSucceeded succeededAction: @escaping ([Tweet]) -> Void, whenFailed failedAction: ((String) -> Void)?) {
        var parameters = [String:String]()
        parameters["exclude_replies"] = "0"
        parameters["since_id"] = "\(oldestId)"
        print("since_id = \(oldestId)")
        self.get(mentionsTimelineURL, parameters: parameters, success: { (task, response) in
            if let tweetDictionaries = response as? [NSDictionary] {
                let  tweets = tweetDictionaries.map{ return Tweet(dictionary:$0)}
                succeededAction(tweets)
            }
        }, failure: { (task, error) in
            if let failedAction = failedAction {
                failedAction((error.localizedDescription))
            }
        })
    }
    
    func newTweet(message: String, whenSucceeded succeededAction: (() -> Void)?, whenFailed failedAction: ((String) -> Void)?) {
        var parameters = [String: String]()
        parameters["status"] = message
        self.post(newTweetURL, parameters: parameters, success: { (task, response) in
            if succeededAction != nil {
                succeededAction!()
            }
        }) { (task, error) in
            if let failedAction = failedAction {
                failedAction(error.localizedDescription)
            }
        }
    }
    
    func retweet(tweetId: String, whenSucceeded succeededAction: (() -> Void)?, whenFailed failedAction: ((String) -> Void)?) {
        let retweetURLStr = retweetURL.replacingOccurrences(of: "tweetId", with: tweetId)
        var parameters = [String: String]()
        parameters["id"] = tweetId
        self.post(retweetURLStr, parameters: parameters, success: { (task, response) in
            if succeededAction != nil {
                succeededAction!()
            }
        }, failure: { (task, error) in
            if let failedAction = failedAction {
                failedAction(error.localizedDescription)
            }
        })
    }
    
    func unretweet(tweetId: String, whenSucceeded succeededAction: (() -> Void)?, whenFailed failedAction: ((String) -> Void)?) {
        let unretweetURLStr = unretweetURL.replacingOccurrences(of: "tweetId", with: tweetId)
        var parameters = [String: String]()
        parameters["id"] = tweetId
        self.post(unretweetURLStr, parameters: parameters, success: { (task, response) in
            if succeededAction != nil {
                succeededAction!()
            }
        }, failure: { (task, error) in
            print(error)
            if let failedAction = failedAction {
                failedAction(error.localizedDescription)
            }
        })
    }
    
    func favorite(tweetId: String, whenSucceeded succeededAction: (() -> Void)?, whenFailed failedAction: ((String) -> Void)?) {
        var parameters = [String: String]()
        parameters["id"] = tweetId
        self.post(favoriteURL, parameters: parameters, success: { (task, response) in
            if succeededAction != nil {
                succeededAction!()
            }
        }, failure: { (task, error) in
            if let failedAction = failedAction {
                failedAction(error.localizedDescription)
            }
        })
    }
    
    func unfavorite(tweetId: String, whenSucceeded succeededAction: (() -> Void)?, whenFailed failedAction: ((String) -> Void)?) {
        var parameters = [String: String]()
        parameters["id"] = tweetId
        self.post(unfavoriteURL, parameters: parameters, success: { (task, response) in
            if succeededAction != nil {
                succeededAction!()
            }
        }, failure: { (task, error) in
            if let failedAction = failedAction {
                failedAction(error.localizedDescription)
            }
        })
    }
    
    func createNewTweet (message: String, whenSucceeded succeededAction: ((Tweet) -> Void)?, whenFailed failedAction: ((String) -> Void)?) {
        var parameters = [String: String]()
        parameters["status"] = message
        self.post(newTweetURL, parameters: parameters, success: { (task, response) in
            if succeededAction != nil {
                let tweet = Tweet(dictionary: (response as? NSDictionary)!)
                succeededAction!(tweet)
            }
        }, failure: { (task, error) in
            if let failedAction = failedAction {
                failedAction(error.localizedDescription)
            }
        })
    }
    
    func replyTweet (message: String, toTweetId: String, whenSucceeded succeededAction: (() -> Void)?, whenFailed failedAction: ((String) -> Void)?) {
        var parameters = [String: String]()
        parameters["status"] = message
        parameters["in_reply_to_status_id"] = toTweetId
        self.post(newTweetURL, parameters: parameters, success: { (task, response) in
            if succeededAction != nil {
                succeededAction!()
            }
        }, failure: { (task, error) in
            if let failedAction = failedAction {
                failedAction(error.localizedDescription)
            }
        })
    }
    
    func setActiveUser(user: User) {
        requestSerializer.saveAccessToken(user.credential)
    }
}
