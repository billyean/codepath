//
//  FirstViewController.swift
//  Flicks
//
//  Created by Yan, Tristan on 3/28/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit
import AFNetworking

class NowPlayingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let api_key = "0a870c2e3daf46a8b6099e99cb0ed595"
    
    var movies: [NSDictionary]?
    
    var sortWay:String = "now_playing" // 0 means now playing, which is default, 1 means top rate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view, typically from a nib.
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(sortWay)?language=en-US&api_key=\(api_key)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let httpError = error {
                print(httpError)  
            } else {
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        NSLog("response: \(responseDictionary)")
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        self.tableView.reloadData()
                    }
                }
            }
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            print(movies.count)
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell
        cell?.titleLabel.text = movie?["title"] as? String
        cell?.content.text = movie?["overview"] as? String
        
        if let imageUriStr = movie?["poster_path"] as? String {
            let imageUrlStr = "https://image.tmdb.org/t/p/w500\(imageUriStr)"
        
            print(imageUrlStr)
            if let imageUrl = URL(string: imageUrlStr) {
                cell?.movieImage.setImageWith(imageUrl)
            }
        }
        
        return cell!
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let controller = viewController as?  NowPlayingViewController
    }
}

