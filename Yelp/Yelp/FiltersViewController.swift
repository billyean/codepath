//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Haibo Yan on 4/6/17.
//  Copyright © 2017 Haibo Yan. All rights reserved.
//

import UIKit

protocol FiltersChangedDelegate: class {
    func filtersChanged(changer: FiltersViewController, filtersDidChange filters: Filters?)
}

class FiltersViewController: UIViewController {
    weak var delegate: FiltersChangedDelegate?

    @IBOutlet weak var filtersTableView: UITableView!
    
    var filters: Filters! = Filters()
    
    var showAllCategories: Bool = false
    
    let HeaderViewIdentifier = "TableViewHeaderView"
    
    var distanceModelCell: ModelCell?
    
    var sortbyModelCell: ModelCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filtersTableView.dataSource = self
        filtersTableView.delegate = self
        
        // Do any additional setup after loading the view.
        filtersTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
        
        let distances = filters.distancesArray.map{  return $0["name"] }  as! [String]
        let distanceSelectIndex = filters.distances
        distanceModelCell = ModelCell(selections: distances, byDefault: distanceSelectIndex, inTableView: filtersTableView)
        distanceModelCell?.delegate = self
        
        let sortedBy = filters.sortByArray.map{  return $0["name"] } as! [String]
        let sortedByIndex = filters.sortBy
        sortbyModelCell = ModelCell(selections: sortedBy, byDefault: sortedByIndex, inTableView: filtersTableView)
        sortbyModelCell?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    */
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
    
    @IBAction func doSearch(_ sender: Any) {
        delegate?.filtersChanged(changer: self, filtersDidChange: filters)
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// Handle table view
extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return distanceModelCell?.rows ?? 0
        case 2:
            return sortbyModelCell?.rows ?? 0
        default:
            if showAllCategories {
                return filters!.categoriesArray.count
            } else {
                return 5
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell0 = filtersTableView.dequeueReusableCell(withIdentifier: "OnOrOffTableViewCell", for: indexPath) as! OnOrOffTableViewCell
            let row = filters.offeringADeal[indexPath.row]
            cell0.OnOrOffLabel.text = row["name"]
            if let value = row["selected"] {
                if value == "true" {
                    cell0.OnOrOffSwitch.isSelected = true
                }
            }
            cell0.delegate = self
            return cell0
        case 1:
            return (distanceModelCell?.cellAtIndexPath(indexPath: indexPath))!
        case 2:
            return (sortbyModelCell?.cellAtIndexPath(indexPath: indexPath))!
        default:
            if !showAllCategories && indexPath.row == 4 {
                let singleLabelCell = filtersTableView.dequeueReusableCell(withIdentifier: "SingleLabelCell", for: indexPath) as! SingleLabelCell
                return singleLabelCell
            }
            let cell3 = filtersTableView.dequeueReusableCell(withIdentifier: "OnOrOffTableViewCell", for: indexPath) as! OnOrOffTableViewCell
            let row = filters.categoriesArray[indexPath.row]
            cell3.OnOrOffLabel.text = row["name"]
            if let value = row["selected"] {
                if value == "true" {
                    cell3.OnOrOffSwitch.isSelected = true
                }
            }
            cell3.delegate = self
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
            distanceModelCell?.tapAt(rowAt: indexPath.row)
        case 2:
            sortbyModelCell?.tapAt(rowAt: indexPath.row)
        case 3:
            if !showAllCategories && indexPath.row == 4 {
                showAllCategories = true
                filtersTableView.reloadData()
            }
        default:
            print("Default")
        }
    }
}

// Handle on/off switch
extension FiltersViewController: SwitchBetweenOnAndOffDelegate {
    func onSwitch(cell: OnOrOffTableViewCell, changedValue value: Bool?) {
        let boolStr = String(describing: value!)
        let indexPath = filtersTableView.indexPath(for: cell)
        if indexPath?.section == 0 {
            filters.offeringADeal[0]["selected"] = boolStr
        } else {
            filters.categoriesArray[(indexPath?.row)!]["selected"] = boolStr
        }
    }
}

extension FiltersViewController: ReSelectDelegate {
    func onChanged(cell:UITableViewCell, changedValue value: Int?) {
        let indexPath = filtersTableView.indexPath(for: cell)
        if indexPath?.section == 1 {
            filters.distances = value!
        } else {
            filters.sortBy = value!
        }
    }
}
