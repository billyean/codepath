//
//  FirstViewController.swift
//  Flicks
//
//  Created by Yan, Tristan on 3/28/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    @IBOutlet weak var networkErrorView: UIView!
    
    @IBOutlet weak var alertImageView: UIImageView!
    
    @IBOutlet weak var networkErrorLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var viewSegmentedController: UISegmentedControl!

    let api_key = "0a870c2e3daf46a8b6099e99cb0ed595"
    
    var movies: [NSDictionary]?
    
    var searchActive: Bool = false
    
    var filteredMovies: [NSDictionary]?
    
    var networkConnected: Bool = true
    
    var sortWay:String = "now_playing" // 0 means now playing, which is default, 1 means top rate
    
    var viewForSearchBar: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        movieSearchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        viewForSearchBar?.autoresizesSubviews = true
        
        if viewSegmentedController.selectedSegmentIndex == 0 {
            tableView.isHidden = false
            collectionView.isHidden = true
        } else {
            tableView.isHidden = true
            collectionView.isHidden = false
        }
        viewSegmentedController.addTarget(self, action: #selector(segmentValueChangeAction(_:)), for: .valueChanged)

        // Do any additional setup after loading the view, typically from a nib.
        let refreshControl1 = UIRefreshControl()
        refreshControl1.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl1, at: 0)
        
        let refreshControl2 = UIRefreshControl()
        refreshControl2.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        collectionView.insertSubview(refreshControl2, at: 0)
        
        MBProgressHUD.showAdded(to: tableView, animated: true)
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(sortWay)?language=en-US&api_key=\(api_key)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let httpError = error {
                self.networkConnected = false
                self.networkErrorView.isHidden = false
                MBProgressHUD.hide(for: self.tableView, animated: true)
                print(httpError)
            } else {
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        self.movies = responseDictionary["results"] as? [NSDictionary]
//                        sleep(10)
                        MBProgressHUD.hide(for: self.tableView, animated: true)
                        self.tableView.reloadData()
                        self.collectionView.reloadData()
                    }
                }
            }
        });
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (networkConnected) {
            networkErrorView.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return (filteredMovies?.count)!
        } else {
            if let movies = movies {
                return movies.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var movie: NSDictionary?
        
        if (searchActive) {
            movie = filteredMovies?[indexPath.row]
        } else {
            movie = movies?[indexPath.row]
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableCell", for: indexPath) as? MovieTableViewCell
        cell?.titleLabel.text = movie?["title"] as? String
        cell?.content.text = movie?["overview"] as? String
        
        if let imageUriStr = movie?["poster_path"] as? String {
            let highResolutionImageUrlStr = "https://image.tmdb.org/t/p/w500\(imageUriStr)"
            let lowResolutionImageUrlStr = "https://image.tmdb.org/t/p/w45\(imageUriStr)"

            let highResolutionImageRequest = URLRequest(url: URL(string: highResolutionImageUrlStr)!)
            let lowResolutionImageRequest = URLRequest(url: URL(string: lowResolutionImageUrlStr)!)
            
            cell?.movieImage.setImageWith(lowResolutionImageRequest,placeholderImage: nil,
                            success: { (lowResolutionImageRequest, lowResolutionResponse, lowResolutionImage) in
                    cell?.movieImage.alpha = 0.0
                    cell?.movieImage.image = lowResolutionImage
                    print("Set low resolution images")
                    UIView.animate(withDuration: 1.0, animations: {() -> Void in
                        cell?.movieImage.alpha = 1.0
                    }, completion: {(success) -> Void in
                        cell?.movieImage.setImageWith(highResolutionImageRequest, placeholderImage: nil,
                                                      success: { (highResolutionImageRequest, highResolutionResponse, highResolutionImage) in
                            print("Set high resolution images")
                            cell?.movieImage.image = highResolutionImage
                        })
                    })
            }, failure: { (request, response, error) in
                print(error)
            })
        }
        cell?.selectionStyle = .none
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkGray
        cell?.selectedBackgroundView = backgroundView
        
        cell?.sizeToFit()
        
        return cell!
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = movies?.filter(){ (movie) -> Bool in
            if let movieTitle = movie["title"] as? String {
                let range = movieTitle.startIndex..<movieTitle.endIndex
                return movieTitle.range(of: searchText, options: .caseInsensitive, range: range, locale: Locale.current) != nil
            }
            return true
        }
        if (filteredMovies?.count == 0) {
            self.searchActive = false
        } else {
            self.searchActive = true
        }
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.movieSearchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.movieSearchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("call searchBarCancelButtonClicked")
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let target = segue.destination as? MovieDetailViewController
        
        var indexPath: IndexPath?
        
        if viewSegmentedController.selectedSegmentIndex == 0 {
            indexPath = tableView.indexPath(for: sender as! UITableViewCell)
        } else {
            indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell)
        }
        
        if (searchActive) {
            target?.movie = filteredMovies?[(indexPath?.row)!]
        } else {
            target?.movie = movies?[(indexPath?.row)!]
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        MBProgressHUD.showAdded(to: tableView, animated: true)
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(sortWay)?language=en-US&api_key=\(api_key)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let httpError = error {
                self.networkConnected = false
                self.networkErrorView.isHidden = false
                MBProgressHUD.hide(for: self.tableView, animated: true)
                print(httpError)
            } else {
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        //                        sleep(10)
                        MBProgressHUD.hide(for: self.tableView, animated: true)
                        self.networkConnected = true
                        self.networkErrorView.isHidden = true
                        self.tableView.reloadData()
                        self.collectionView.reloadData()
                    }
                }
            }
            refreshControl.endRefreshing()
        });
        task.resume()
    }
    
    func segmentValueChangeAction(_ viewSegmentedController: UISegmentedControl) {
        if viewSegmentedController.selectedSegmentIndex == 0 {
            tableView.isHidden = false
            collectionView.isHidden = true
        } else {
            tableView.isHidden = true
            collectionView.isHidden = false
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchActive) {
            return (filteredMovies?.count)!
        } else {
            if let movies = movies {
                return movies.count
            } else {
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as? MovieCollectionViewCell
        
        var movie: NSDictionary?
        
        if (searchActive) {
            movie = filteredMovies?[indexPath.row]
        } else {
            movie = movies?[indexPath.row]
        }
        
        if let imageUriStr = movie?["poster_path"] as? String {
            let highResolutionImageUrlStr = "https://image.tmdb.org/t/p/w500\(imageUriStr)"
            let lowResolutionImageUrlStr = "https://image.tmdb.org/t/p/w45\(imageUriStr)"
            
            let highResolutionImageRequest = URLRequest(url: URL(string: highResolutionImageUrlStr)!)
            let lowResolutionImageRequest = URLRequest(url: URL(string: lowResolutionImageUrlStr)!)
            
            cell?.movieImage.setImageWith(lowResolutionImageRequest,placeholderImage: nil,
                    success: { (lowResolutionImageRequest, lowResolutionResponse, lowResolutionImage) in
                        cell?.movieImage.alpha = 0.0
                        cell?.movieImage.image = lowResolutionImage
                        UIView.animate(withDuration: 1.0, animations: {() -> Void in
                            cell?.movieImage.alpha = 1.0
                        }, completion: {(success) -> Void in
                            cell?.movieImage.setImageWith(highResolutionImageRequest, placeholderImage: nil,
                                                          success: { (highResolutionImageRequest, highResolutionResponse, highResolutionImage) in
                                                            cell?.movieImage.image = highResolutionImage
                            })
                        })
            }, failure: { (request, response, error) in
                print(error)
            })
        }
        
        cell?.sizeToFit()
        
        return cell!
    }
}

