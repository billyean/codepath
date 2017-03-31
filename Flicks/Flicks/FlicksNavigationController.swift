//
//  FlicksNavigationControllerViewController.swift
//  Flicks
//
//  Created by Yan, Tristan on 3/31/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class FlicksNavigationController: UINavigationController {

    var type:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let moviewController = viewControllers[0] as? MoviesViewController
        moviewController?.sortWay = type!
        
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
