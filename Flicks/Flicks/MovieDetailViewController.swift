//
//  MovieDetailViewController.swift
//  Flicks
//
//  Created by Yan, Tristan on 3/29/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movie: NSDictionary?

    @IBOutlet weak var movieImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let imageUriStr = movie?["poster_path"] as? String {
            let imageUrlStr = "https://image.tmdb.org/t/p/w500\(imageUriStr)"
            
            if let imageUrl = URL(string: imageUrlStr) {
                movieImageView.setImageWith(imageUrl)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
