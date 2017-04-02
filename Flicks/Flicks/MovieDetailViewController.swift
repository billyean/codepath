//
//  MovieDetailViewController.swift
//  Flicks
//
//  Created by Yan, Tristan on 3/29/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailViewController: UIViewController {
    
    var movie: NSDictionary?

    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
    
    @IBOutlet weak var popularity: UILabel!
    
    @IBOutlet weak var time: UILabel!

    @IBOutlet weak var overview: UILabel!
    
    @IBOutlet weak var contextView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let api_key = "0a870c2e3daf46a8b6099e99cb0ed595"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentWidth = scrollView.bounds.width
        let contentHeight = contextView.bounds.height
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        scrollView.addSubview(contextView)

        // Do any additional setup after loading the view.
        if let imageUriStr = movie?["poster_path"] as? String {
            let highResolutionImageUrlStr = "https://image.tmdb.org/t/p/w500\(imageUriStr)"
            let lowResolutionImageUrlStr = "https://image.tmdb.org/t/p/w45\(imageUriStr)"
            
            let highResolutionImageRequest = URLRequest(url: URL(string: highResolutionImageUrlStr)!)
            let lowResolutionImageRequest = URLRequest(url: URL(string: lowResolutionImageUrlStr)!)
            
            movieImageView.setImageWith(lowResolutionImageRequest,placeholderImage: nil,
                success: { (lowResolutionImageRequest, lowResolutionResponse, lowResolutionImage) in
                    self.movieImageView.alpha = 0.0
                    self.movieImageView.image = lowResolutionImage
                    UIView.animate(withDuration: 0.3, animations: {() -> Void in
                        self.movieImageView.alpha = 1.0
                    }, completion: {(success) -> Void in
                        self.movieImageView.setImageWith(highResolutionImageRequest, placeholderImage: nil,
                            success: { (highResolutionImageRequest, highResolutionResponse, highResolutionImage) in
                                self.movieImageView.image = highResolutionImage
                            })
                        })
                }, failure: { (request, response, error) in
                print(error)
            })
        }
        
        movieTitle.text = movie?["original_title"] as! String
        
        let dateString = movie?["release_date"] as! String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateStyle = .medium
        releaseDate.text = dateFormatter.string(from: date!)

        overview.text = movie?["overview"] as! String
        overview.sizeToFit()
        
        let popularityVal = movie?["popularity"] as! Double
        
        popularity.text = String.init(format: "%.0f", popularityVal)

        let movie_id = movie?["id"] as! Int
        
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(movie_id)?api_key=\(api_key)&language=en-US")
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
                        let runtime = responseDictionary["runtime"] as! Int
                        self.time.text = self.intToTimeStr(runtime)
                    }
                }
            }
        });
        task.resume()
        //let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(MovieDetailViewController.swiped(_:)))
        //swipeUp.direction = .up
        //self.contextView.addGestureRecognizer(swipeUp)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func intToTimeStr(_ time: Int) -> String {
        let hh = time / 60
        let mm = time - hh * 60
        return String.init(format: "%d hr %d minutes", hh, mm)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func swiped(_ gesture: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.contextView.center.y -= 50
        }, completion: { (success) -> Void in
            self.contextView.center.y += 50
        })
    }

}
