//
//  MainViewController.swift
//  TwitterRedux
//
//  Created by Yan, Tristan on 4/18/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var originalLeftMargin: CGFloat!
    
    var menuViewPercentage: CGFloat = 50

    var menuViewController: MainMenuViewController?
    
    var lastAccessedViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        menuViewController = storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController") as? MainMenuViewController
        menuView.addSubview((menuViewController?.view)!)
        menuViewController?.hamburgerController = self
        
        let profileViewController = storyboard?.instantiateViewController(withIdentifier: "ProfileNavagationController") as? UINavigationController
        menuViewController?.addMenu("Profile", withTagetController: profileViewController!)
        
        let timelinesViewController = storyboard?.instantiateViewController(withIdentifier: "TimelinesNavigationController") as? UINavigationController
        menuViewController?.addMenu("Timelines", withTagetController: timelinesViewController!)
        
        let mentionsViewController = storyboard?.instantiateViewController(withIdentifier: "MentionsNavigationController") as? UINavigationController
        menuViewController?.addMenu("Mentions", withTagetController: mentionsViewController!)
        
        let accountViewController = storyboard?.instantiateViewController(withIdentifier: "AccountsViewController") as? AccountsViewController
        menuViewController?.addMenu("Account", withTagetController: accountViewController!)
        
        if lastAccessedViewController == nil {
            lastAccessedViewController = accountViewController
        }
        if let lastAccessedViewController = lastAccessedViewController {
            setDefaultContentViewController(viewController: lastAccessedViewController)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        switch sender.state {
        case UIGestureRecognizerState.began:
            originalLeftMargin = leftMarginConstraint.constant
        case UIGestureRecognizerState.changed:
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        case UIGestureRecognizerState.ended:
            UIView.animate(withDuration: 0.3, animations: {
                if velocity.x > 0 {
                    self.leftMarginConstraint.constant = self.view.frame.size.width * self.menuViewPercentage / 100
                } else {
                    self.leftMarginConstraint.constant = 0
                }
            })
        default:
            break
        }
    }
    
    func addControllerViewToContentView(viewController: UIViewController) {
        lastAccessedViewController = viewController
        contentView.addSubview((viewController.view)!)
        UIView.animate(withDuration: 0.3, animations: {
            self.leftMarginConstraint.constant = 0
        })
    }
    
    func setDefaultContentViewController(viewController: UIViewController) {
        contentView.addSubview(viewController.view)
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
