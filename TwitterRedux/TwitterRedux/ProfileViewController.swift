//
//  ProfileViewController.swift
//  TwitterRedux
//
//  Created by Yan, Tristan on 4/21/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class ProfileViewController: CommonViewController {
    var headerView: ProfileTableViewCell?

//    var contentOriginY: CGFloat?
//    
//    var originHeaderHeight: CGFloat?
    
    var user = User.sharedUserGroup.activeUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.y
        let headerView = tweetsTableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as? ProfileTableViewCell
        headerView?.setModel(model: user)
        tweetsTableView.tableHeaderView = headerView
//        originHeaderHeight = headerView?.bounds.height

        TwitterClient.sharedInstance.fetchUserTimeline(
            user.id!,
            whenSucceeded: { (timelines) in
            self.tweets = timelines
            self.tweetsTableView.reloadData()
        }, whenFailed: nil)

        loadTweetClousure = getLoadTweetClousure()
        loadMoreTweetClousure = getLoadMoreTweetClousure()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func getLoadTweetClousure() -> ((@escaping ([Tweet]) -> Void, ((String) -> Void)?) -> ())? {
        func loadTweetClousure(succeed: @escaping ([Tweet]) -> Void, failed: ((String) -> Void)?) {
            return TwitterClient.sharedInstance.fetchUserTimeline(user.id!, whenSucceeded: succeed, whenFailed: failed)
        }
        return loadTweetClousure
    }
    
    func getLoadMoreTweetClousure() -> ((Int, @escaping ([Tweet]) -> Void, ((String) -> Void)?) -> ())? {
        func loadMoreTweetClousure(oldestId: Int, succeed: @escaping ([Tweet]) -> Void, failed: ((String) -> Void)?) {
            return TwitterClient.sharedInstance.fetchMoreUserTimeline(user.id!, oldestId: oldestId, whenSucceeded: succeed, whenFailed: failed)
        }
        return loadMoreTweetClousure
    }
}



