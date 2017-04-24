//
//  User.swift
//  TwitterClient
//
//  Created by Yan, Tristan on 4/13/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class User: NSObject {
    static let sharedUserGroup =  UserGroup()
    
    class UserGroup {
        let persistentUsersKey = "com.haiyan.TwitterRedux.users"
        
        let persistentUsersCredentialKey = "com.haiyan.TwitterRedux.credentials"
        
        let persistentUserIndexKey = "com.haiyan.TwitterRedux.activeIndex"
        
        var users = [User]()
        
        var activeUser: User?
        
        init () {
            let dataUsers = UserDefaults.standard.data(forKey: persistentUsersKey)
            let dataCredentials = UserDefaults.standard.data(forKey: persistentUsersCredentialKey)
            
            if dataUsers != nil && dataCredentials != nil {
                do {
                    let userDictionaries = try JSONSerialization.jsonObject(with: dataUsers!, options: []) as? [[String: Any]]
                    let userCredentials = try JSONSerialization.jsonObject(with: dataCredentials!, options: []) as? [[String: Any]]
                    if userDictionaries != nil {
                        for (index, userDictionary) in userDictionaries!.enumerated() {
                            let user = User(dictionay: userDictionary)
                            user.setCredentialDictionary((userCredentials?[index])!)
                            users.append(user)
                        }
                        let index = UserDefaults.standard.integer(forKey: persistentUserIndexKey)
                        if users.count > 0 {
                            activeUser = users[index]
                            TwitterClient.sharedInstance.setActiveUser(user: activeUser!)
                        }
                    }
                } catch {
                    print("Error happened when deserialize user")
                }
            }
        }
        
        func setActive(user: User) {
            activeUser = user
            TwitterClient.sharedInstance.setActiveUser(user: user)
        }
        
        func activateUser(user: User) {
            activeUser = user
            for index in 0..<users.count {
                if users[index].id == user.id {
                    users[index] = user
                }
            }
            persistent()
        }
        
        func persistentNewUser(user: User) -> Bool{
            let existed = users.filter{ return $0.id == user.id }
            if existed.count == 0 {
                activeUser = user
                users.append(user)
                persistent()
                return true
            } else {
                activeUser = existed[0]
                return false
            }
        }
        
        func removeUser(at index: Int) {
            let user = users[index]
            users.remove(at: index)
            if users.count == 0 {
                activeUser = nil
            } else if activeUser == user {
                activeUser = users[0]
            }

            persistent()
        }
        
        func persistent() {
            let data = users.map({   return $0.savedDictionary })
            do {
                try UserDefaults.standard.set(JSONSerialization.data(withJSONObject: data, options: []), forKey: persistentUsersKey)
            } catch {
                print("Error happened when persistent user")
            }
            let credentialData = users.map({   return $0.dictionaryOfCredential() })
            do {
                try UserDefaults.standard.set(JSONSerialization.data(withJSONObject: credentialData, options: []), forKey: persistentUsersCredentialKey)
            } catch {
                print("Error happened when persistent credentials")
            }
            
            var index = -1
            
            if activeUser != nil {
               index = users.index(of: activeUser!)!
            }
            UserDefaults.standard.set(index, forKey: persistentUserIndexKey)
        }
    }
    
    var id: String?
    
    var name: String?
    
    var screenName: String?
    
    var profileImageURL: URL?
    
    var bannerImageURL: URL?
    
    var tweetsCount: Int?
    
    var followingCount: Int?
    
    var followersCount: String?
    
    var profileDescription: String?
    
    var tagline: String?
    
    var address: String?
    
    var savedDictionary: [String: Any]
    
    var credential: BDBOAuth1Credential?
    
    init(dictionay: [String: Any]) {
        id = dictionay["id_str"] as? String
        name = dictionay["name"] as? String
        screenName = dictionay["screen_name"] as? String
        
        if let profileURLStr = dictionay["profile_image_url_https"] as? String {
            profileImageURL = URL(string: profileURLStr)
        }
        
        if let bannerImageURLStr = dictionay["profile_banner_url"] as? String {
            bannerImageURL = URL(string: bannerImageURLStr)
        }

        tagline = dictionay["description"] as? String
        tweetsCount = dictionay["description"] as? Int
        followingCount = dictionay["following"] as? Int
        followersCount = dictionay["followers_count"] as? String
        profileDescription = dictionay["description"] as? String
        address = dictionay["location"] as? String
        savedDictionary = dictionay
    }

    
    func setCredential(userCredential: BDBOAuth1Credential) {
        credential = userCredential
    }
    
    func dictionaryOfCredential() -> [String: Any] {
        var dict = [String: Any]()
        if let credential = credential {
            dict["accessToken"] = credential.token
            dict["secret"] = credential.secret
            if credential.verifier != nil {
                dict["verifier"] = credential.verifier
            }
        }
        return dict
    }
    
    func setCredentialDictionary(_ dictionary: [String: Any]) {
        if dictionary.isEmpty {
            credential = nil
        } else {
            let accessToken = dictionary["accessToken"] as! String
            let secret = dictionary["secret"] as! String
            let verifier = dictionary["verifier"] as? Date
            credential =  BDBOAuth1Credential(token: accessToken, secret: secret, expiration: verifier)
        }
    }
    
    func setCurrentUserActive() {
        User.sharedUserGroup.setActive(user: self)
    }
    
    func deauthorize() {
        TwitterClient.sharedInstance.logout()
        credential = nil
        User.sharedUserGroup.persistent()
    }
    
    func isLogined() -> Bool {
        return credential != nil
    }
}
