//
//  ViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit
import MBProgressHUD
import AFNetworking

// Main ViewController
class RepoResultsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var repoTableView: UITableView!
    var searchBar: UISearchBar!
    var settingsButton: UIBarButtonItem!
    
    var searchSettings = GithubRepoSearchSettings()

    var repos: [GithubRepo]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        repoTableView.delegate = self
        repoTableView.dataSource = self

        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self

        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
//        
//        settingsButton = UIBarButtonItem()
//        settingsButton.title = "Settings"
//        settingsButton.action = #selector(performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>))
//        navigationItem.leftBarButtonItem = settingsButton
//        
//        

        // Perform the first search when the view controller first loads
        doSearch()
        
    }

    // Perform the search.
    fileprivate func doSearch() {

        MBProgressHUD.showAdded(to: self.view, animated: true)

        // Perform request to GitHub API to get the list of repositories
        GithubRepo.fetchRepos(searchSettings, successCallback: { (newRepos) -> Void in

            // Print the returned repositories to the output window
            for repo in newRepos {
                print(repo)
            }
            self.repos = newRepos
            
            self.repoTableView.reloadData()

            MBProgressHUD.hide(for: self.view, animated: true)
            }, error: { (error) -> Void in
                print(error)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if repos != nil {
            print(repos.count)
            return repos.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoTableViewCell", for: indexPath) as! RepoTableViewCell
        let repo =  repos[indexPath.row]
        cell.nameLabel.text = repo.name
        cell.authorLabel.text = "by \(repo.ownerHandle!)"

        cell.forkLabel.text = "\(repo.forks!)"
        cell.starLabel.text = "\(repo.stars!)"
        let imageUrl = URL(string: repo.ownerAvatarURL!)
        cell.authorImage.setImageWith(imageUrl!)
        cell.descriptionLabel.text = repo.repoDescription
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let segue.destination as
    }
}

// SearchBar methods
extension RepoResultsViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
}
