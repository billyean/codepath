//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Yan, Tristan on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var filtersTableView: UITableView!
    
    weak var filters: Filters!
    
    var distanceDropped: Bool = false
    
    var sortByDropped: Bool = false
    
    var showAllCategories: Bool = false
    
    let HeaderViewIdentifier = "TableViewHeaderView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filtersTableView.dataSource = self
        filtersTableView.delegate = self

        // Do any additional setup after loading the view.
        filtersTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if distanceDropped {
                return filters.distancesArray.count
            } else {
                return 1
            }
        case 2:
            if sortByDropped {
                return filters.sortByArray.count
            } else {
                return 1
            }
        default:
            if showAllCategories {
                return filters.categories.count
            } else {
                return 21
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell0 = filtersTableView.dequeueReusableCell(withIdentifier: "OnOrOffTableViewCell", for: indexPath) as! OnOrOffTableViewCell
            let row = filters.offeringADeal[indexPath.row]
            cell0.OnOrOffLabel.text = row["name"]
            if let value = row["value"] {
                if value == "true" {
                    cell0.OnOrOffSwitch.isOn = true
                }
            }
            return cell0
        case 1:
            if distanceDropped {
                let cell1 = filtersTableView.dequeueReusableCell(withIdentifier: "MultipleSelectionTableViewCell", for: indexPath) as! MultipleSelectionTableViewCell
                let row1 = filters.distancesArray[indexPath.row]
                cell1.nameLabel.text = row1["name"]
                if indexPath.row == filters.distances {
                    cell1.checkedImage.image = UIImage(named: "checked.png")
                } else {
                    cell1.checkedImage.image = UIImage(named: "unchecked.png")
                }
                return cell1
            } else {
                let cell1 = filtersTableView.dequeueReusableCell(withIdentifier: "DropdownTableViewCell", for: indexPath) as! DropdownTableViewCell
                let element = filters.distancesArray[filters.distances]
                cell1.nameLabel.text = element["name"]
                return cell1
            }
        case 2:
            if sortByDropped {
                let cell2 = filtersTableView.dequeueReusableCell(withIdentifier: "MultipleSelectionTableViewCell", for: indexPath) as! MultipleSelectionTableViewCell
                let row2 = filters.sortByArray[indexPath.row]
                cell2.nameLabel.text = row2["name"]
                if indexPath.row == filters.sortBy {
                    cell2.checkedImage.image = UIImage(named: "checked.png")
                } else {
                    cell2.checkedImage.image = UIImage(named: "unchecked.png")
                }
                return cell2
            } else {
                let cell2 = filtersTableView.dequeueReusableCell(withIdentifier: "DropdownTableViewCell", for: indexPath) as! DropdownTableViewCell
                let element = filters.sortByArray[filters.sortBy]
                cell2.nameLabel.text = element["name"]
                return cell2
            }
        default:
            let cell3 = filtersTableView.dequeueReusableCell(withIdentifier: "OnOrOffTableViewCell", for: indexPath) as! OnOrOffTableViewCell
            let row = filters.categories[indexPath.row]
            cell3.OnOrOffLabel.text = row["name"]
            if let value = row["value"] {
                if value == "true" {
                    cell3.OnOrOffSwitch.isOn = true
                }
            }
            return cell3
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = filtersTableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderViewIdentifier)!
        switch section {
        case 1:
            header.textLabel?.text = "Distance"
        case 2:
            header.textLabel?.text = "Sort By"
        case 3:
            header.textLabel?.text = "Category"
        default: break
            //
        }
        header.backgroundView?.backgroundColor = .white
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat(8.0)
        } else {
            return CGFloat(32.0)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            if distanceDropped {
                filters.distances = indexPath.row
            }
            distanceDropped = !distanceDropped
            filtersTableView.reloadData()
        case 2:
            if sortByDropped {
                filters.sortBy = indexPath.row
            }
            sortByDropped = !sortByDropped
            filtersTableView.reloadData()
        default:
            print("Default")
        }
    }

    @IBAction func cancelSetting(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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