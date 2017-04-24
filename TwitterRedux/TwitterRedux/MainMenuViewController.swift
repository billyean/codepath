//
//  MainMenuViewController.swift
//  TwitterRedux
//
//  Created by Yan, Tristan on 4/22/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var hamburgerController: HamburgerViewController?
    
    var menus = [String: UIViewController]()
    
    var menuTitles = [String]()
    
    var savedBgColor: UIColor!
    
    var selectedIndexPath: IndexPath?
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var menusTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menusTableView.delegate = self
        menusTableView.dataSource = self
        savedBgColor = view.backgroundColor!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setHambugerController(controller: HamburgerViewController) {
        hamburgerController = controller
    }
    
    func addMenu(_ menu:String, withTagetController targetController: UIViewController) {
        menuTitles.append(menu)
        menus[menu] = targetController
        menusTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menusTableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as? MenuTableViewCell
        cell?.menuTitleLabel.text = menuTitles[indexPath.row]

        return cell!
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if selectedIndexPath != nil {
            if selectedIndexPath?.row == indexPath.row && selectedIndexPath?.section == indexPath.section {
                return nil
            }
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = menuTitles[indexPath.row]
        let controller = menus[title]
        if controller is UINavigationController {
            let navigationController = controller as? UINavigationController
            navigationController?.visibleViewController?.viewDidLoad()
        } else {
            controller?.viewDidLoad()
        }
        
        hamburgerController?.addControllerViewToContentView(viewController: controller!)
        selectedIndexPath = indexPath
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = menusTableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as? MenuTableViewCell
        cell?.backgroundColor = savedBgColor
        cell?.selectionStyle = .default
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
