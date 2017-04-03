//
//  ViewController.swift
//  TipCalculatorIphone
//
//  Created by Yan, Tristan on 2/27/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let amount_key = "TipCalculator.amount"
    
    let current_time_key = "TipCalculator.saveDate"
    
    let percentages_array_key = "TipCalculator.percentages"

    let percentage_index_key = "TipCalculator.defaultPercentageIndex"
    
    let ten_minutes: TimeInterval = 60.0 * 10
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var amountField: UITextField!
    
    @IBOutlet weak var amountTitle: UILabel!
    @IBOutlet weak var percentSegment: UISegmentedControl!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var initAmount: UITextField!

    
    let defaults = UserDefaults.standard
    var currencyFormatter = NumberFormatter()
    
    @IBOutlet weak var settingBarButton: UIBarButtonItem!
    var firstTime = true

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad ()")
        // Do any additional setup after loading the view, typically from a nib.
        loadDefault()
        
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = .current
    }

    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func amountChanged(_ sender: AnyObject) {
        let percentages = defaults.array(forKey: percentages_array_key)
        
        let amount = Double(amountField.text!) ?? 0.0
        let tip = amount * (percentages?[percentSegment.selectedSegmentIndex] as? Double)! / 100.0
        let total = amount + tip
        tipLabel.text = currencyFormatter.string(from: tip as NSNumber)
        totalLabel.text = currencyFormatter.string(from: total as NSNumber)
    }

    @IBAction func tapOnPanel(_ sender: AnyObject) {
        view.endEditing(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        if let amount = Double(amountField.text!) {
            print("save (amount_key): (amount)")
            defaults.set(amount, forKey: amount_key)
            defaults.set(Date(), forKey: current_time_key)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (firstTime) {
            let locale = Locale.current
            let currencySymbol = locale.currencySymbol
            initAmount.text = currencySymbol! 
            
            if let saveDate = defaults.object(forKey: current_time_key) {
                let interval = Date().timeIntervalSince(saveDate as! Date)
                if  interval <= ten_minutes {
                    let savedAmt = defaults.double(forKey: amount_key)
                    var amountText = ""
                    if savedAmt != 0.0 {
                        amountText = currencyFormatter.string(from: savedAmt as NSNumber)!
                    }
                    initAmount.text = amountText
                    amountField.text = String(savedAmt)
                }
            }
            totalLabel.text = "(currencySymbol)0.00"
            tipLabel.text = "(currencySymbol)0.00"
            
            amountTitle.center.x -= view.bounds.width
            amountField.center.x -= view.bounds.width
            percentSegment.center.x -= view.bounds.width
            bottomView.center.x -= view.bounds.width
            firstTime = false
        }
        loadDefault()
        amountChanged(self)
    }
    
    @IBAction func getFocus(_ sender: AnyObject) {
        UIView.animate(withDuration: 0.4, animations: {
            // This causes first view to fade in and second view to fade out
            self.initAmount.center.x -= self.view.bounds.width
            self.amountTitle.center.x += self.view.bounds.width
            self.amountField.center.x += self.view.bounds.width
            self.percentSegment.center.x += self.view.bounds.width
            self.bottomView.center.x += self.view.bounds.width
            self.settingBarButton.isEnabled = true
            self.amountField.inputView?.becomeFirstResponder()
        })
    }
    
    
    func loadDefault() {
        var defaultPercentages = defaults.array(forKey: percentages_array_key)
        if defaultPercentages == nil {
            defaultPercentages = [15, 18, 20]
            defaults.set(defaultPercentages, forKey: percentages_array_key)
        }
        
        percentSegment.removeAllSegments()
        for (i, element) in (defaultPercentages?.enumerated())! {
            percentSegment.insertSegment(withTitle: String(format: "%d%%", element as! Int), at: i, animated: false)
        }
        
        let selectedPercentageIndex = defaults.integer(forKey: percentage_index_key)
        if percentSegment.selectedSegmentIndex != selectedPercentageIndex {
            percentSegment.selectedSegmentIndex = selectedPercentageIndex
        }
    }
}

