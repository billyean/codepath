//
//  UserProfileViewController.swift
//  TwitterRedux
//
//  Created by Yan, Tristan on 4/23/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class UserProfileViewController: CommonViewController {
    var screenName: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        signBarButtonItem.title = "<"
        self.navigationItem.rightBarButtonItems = nil
        
        TwitterClient.sharedInstance.fetchUser(screenName: screenName, whenSucceeded: { (user) in
            self.navigationItem.title = user.name
            let headerView = self.tweetsTableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as? ProfileTableViewCell
            headerView?.setModel(model: user)
            self.tweetsTableView.tableHeaderView = headerView
            
            self.loadTweetClousure = self.getLoadTweetClousure(user)
            self.loadMoreTweetClousure = self.getLoadMoreTweetClousure(user)
            TwitterClient.sharedInstance.fetchUserTimeline(user.id!,
                whenSucceeded: { (timelines) in
                    self.tweets = timelines
                    self.tweetsTableView.reloadData()
            }, whenFailed: nil)
        }, whenFailed: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction override func sign(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getLoadTweetClousure(_ user: User) -> ((@escaping ([Tweet]) -> Void, ((String) -> Void)?) -> ())? {
        func loadTweetClousure(succeed: @escaping ([Tweet]) -> Void, failed: ((String) -> Void)?) {
            return TwitterClient.sharedInstance.fetchUserTimeline(user.id!, whenSucceeded: succeed, whenFailed: failed)
        }
        return loadTweetClousure
    }
    
    func getLoadMoreTweetClousure(_ user: User) -> ((Int, @escaping ([Tweet]) -> Void, ((String) -> Void)?) -> ())? {
        func loadMoreTweetClousure(oldestId: Int, succeed: @escaping ([Tweet]) -> Void, failed: ((String) -> Void)?) {
            return TwitterClient.sharedInstance.fetchMoreUserTimeline(user.id!, oldestId: oldestId, whenSucceeded: succeed, whenFailed: failed)
        }
        return loadMoreTweetClousure
    }
}
