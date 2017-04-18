//
//  ModelCell.swift
//  Usage:
//  1. In your view controller, declare a ModelCell property, initiate ModelCell in viewDidLoad
//          var modelCell: ModelCell!
//      override func viewDidLoad() {
//          ........
//          let labels = ["Item1", "Item2", "Item3"]
//          let defaultSelection = 0
//          modelCell = ModelCell(selections: labels, byDefault: defaultSelection, inTableView: tableView)
//  2. In your tableView.numberOfRowsInSection, return modelCell's rows property 
//      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//          ........
//          return modelCell?.rows ?? 0
//  3. In your tableView.cellForRowAt, return modelCell's cellAtIndexPath method by given indexPath
//      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//          ........
//          return (modelCell?.cellAtIndexPath(indexPath: indexPath))!
//  4. In your tableView.didSelectRowAt, call modelCell's tapAt method by given indexPath.row
//      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//          modelCell?.tapAt(rowAt: indexPath.row)
//  5. If you need get the result, please set the delegate for ModelCell as following
//          modelCell.delegate = [Your delegate object]
//
//  Created by Haibo Yan on 4/18/17.
//  Copyright © 2017 Haibo Yan. All rights reserved.
//

import UIKit

//
// Single label droppable table view cell
//
protocol ReSelectDelegate: class {
    func onChanged(cell:UITableViewCell, changedValue value: Int?)
}

class SingleCell: UITableViewCell {
    
    @IBOutlet weak var selectedLabel: UILabel!
    
    @IBOutlet weak var downImageView: UIImageView!
    
    override var reuseIdentifier: String? {
        return "SingleCell"
    }
}

class MultipleSelectionCell: UITableViewCell {
    
    @IBOutlet weak var selectionLabel: UILabel!
    

    @IBOutlet weak var checkedImageView: UIImageView!
    
    override var reuseIdentifier: String? {
        return "MultipleSelectionCell"
    }
}

class ModelCell: NSObject {
    var delegate: ReSelectDelegate?
    
    var choices: [String]?
    
    var selectedIndex: Int? {
        willSet {
            selectionCells?[newValue!].checkedImageView?.image = UIImage(named: "checked.png")
            single?.selectedLabel.text = selectionCells?[newValue!].selectionLabel.text
        }
        didSet {
            selectionCells?[oldValue!].checkedImageView.image = UIImage(named: "unchecked.png")
            if delegate != nil {
                delegate!.onChanged(cell: (selectionCells?[selectedIndex!])!, changedValue: selectedIndex)
            }
        }
    }

    var dropped:Bool = false
    
    var tableView: UITableView!
    
    var single: SingleCell?
    
    var selectionCells: [MultipleSelectionCell]?
    
    init (selections: [String], byDefault defaultIndex: Int, inTableView view: UITableView) {
        super.init()
        choices = selections
        selectedIndex = defaultIndex
        tableView = view
        
        single = Bundle.main.loadNibNamed("SingleCell", owner: view, options: nil)?.first as? SingleCell
        
        single?.selectedLabel.text = selections[defaultIndex]
        
        selectionCells = [MultipleSelectionCell]()
        for index in 0..<selections.count {
            let multiple = Bundle.main.loadNibNamed("MultipleSelectionCell", owner: view, options: nil)?.first as! MultipleSelectionCell
            multiple.selectionLabel.text = selections[index]
            if index == defaultIndex {
                multiple.checkedImageView.image = UIImage(named: "checked.png")
            } else {
                multiple.checkedImageView.image = UIImage(named: "unchecked.png")
            }
            selectionCells?.append(multiple)
        }
    }
    
    var rows: Int {
        get {
            if dropped {
                return choices!.count
            } else {
                return 1
            }
        }
    }
    
    func cellAtIndexPath(indexPath: IndexPath) -> UITableViewCell {
        if dropped {
            return selectionCells![indexPath.row]
        } else {
            return single!
        }
    }
    
    func tapAt(rowAt: Int) {
        if dropped {
            selectedIndex = rowAt
            dropped = false
            tableView.reloadData()
        } else {
            dropped = true
            tableView.reloadData()
        }
    }
}
