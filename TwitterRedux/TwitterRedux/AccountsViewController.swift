//
//  AccountsViewController.swift
//  TwitterRedux
//
//  Created by Yan, Tristan on 4/21/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController{
    
    let alertView = UIAlertController(title: "Error",
                                      message: "Authentication Error, please try again." as String, preferredStyle:.alert)
    
    let alertDuplicate = UIAlertController(title: "Duplicate User",
                                      message: "This account has been added, please use different user." as String, preferredStyle:.alert)
    
    var savedBgColor: UIColor?
    
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    @IBOutlet weak var accountsTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Showing AccountsViewController")

        // Do any additional setup after loading the view.
        accountsTableView.delegate = self
        accountsTableView.dataSource = self
        
        accountsTableView.rowHeight = UITableViewAutomaticDimension
        accountsTableView.estimatedRowHeight = 130
        
        alertDuplicate.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.alertDuplicate.dismiss(animated: true, completion: nil)
        }))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func removeUser(_ sender: UIPanGestureRecognizer) {
        print("Received gesture")
        if sender.state == UIGestureRecognizerState.ended {
            let velocity = sender.velocity(in: view)
            if velocity.x > 0 {
                let cell = sender.view as? UITableViewCell
                let indexPath = accountsTableView.indexPath(for: cell!)
                if let removedIndex = indexPath?.row {
                    User.sharedUserGroup.removeUser(at: removedIndex)
                    accountsTableView.reloadData()
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addNewUser(_ sender: Any) {
        TwitterClient.sharedInstance.login(whenSucceeded: {(user) in
            if User.sharedUserGroup.persistentNewUser(user: user) {
                self.accountsTableView.reloadData()
            } else {
                self.present(self.alertDuplicate, animated: true, completion: nil)
            }
        }, whenFailed: {(error) in
            let okAction = UIAlertAction(title: error, style: .default, handler: nil)
            self.alertView.addAction(okAction)
            self.present(self.alertView, animated: true, completion: nil)
        })
    }
}

extension AccountsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("line = \(User.sharedUserGroup.users.count + 1)")
        return User.sharedUserGroup.users.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == User.sharedUserGroup.users.count {
            let cell = accountsTableView.dequeueReusableCell(withIdentifier: "AddAccountTableViewCell", for: indexPath)
            return cell
        } else {
            let cell = accountsTableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell", for: indexPath) as? AccountTableViewCell
            let account = User.sharedUserGroup.users[indexPath.row]
            cell?.accountImageView.setImageWith(account.profileImageURL!)
            cell?.accountNameLabel.text = account.name
            cell?.screenNameLabel.text = "@\((account.screenName)!)"
            cell?.addGestureRecognizer(panGesture)
            return cell!
        }
    }

    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = accountsTableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell", for: indexPath) as? AccountTableViewCell
        savedBgColor = cell?.backgroundColor
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < User.sharedUserGroup.users.count {
            User.sharedUserGroup.setActive(user: User.sharedUserGroup.users[indexPath.row])
            let cell = accountsTableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell", for: indexPath) as? AccountTableViewCell
            cell?.backgroundColor = savedBgColor
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}
