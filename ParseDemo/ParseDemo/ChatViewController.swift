//
//  ChatViewController.swift
//  ParseDemo
//
//  Created by Tummala, Balaji on 4/12/17.
//  Copyright © 2017 Tummala, Balaji. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var messages=[AnyObject]()
    @IBAction func compose(_ sender: Any) {
        
        var message = PFObject(className: "Message")
        message["text"] = chatLabel.text
        message["user"] = PFUser.current()
        
        message.saveInBackground(block: {(success,error)                        in
            if success {
               print("Message Saved")
            } else {
                print("Save Failed")
            }
        })
    }
    @IBOutlet weak var chatLabel: UITextField!
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: (#selector(ChatViewController.onTimer)), userInfo: nil, repeats: true)
        onTimer()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages == nil {
            return 0
        } else {
            print(messages.count)
            return (messages.count)
        }
    }
    
    func onTimer(){
        let query = PFQuery(className:"Message")
        query.findObjectsInBackground(block: {(objects,error) in
            if error == nil {
                if let objects = objects {
                    for obj in objects {
                        self.messages.append(obj)
                    }
                    print(self.messages.count)
                    
                }
                self.tableView.reloadData()
            }
            
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        let message = messages[indexPath.row] as! PFObject
        cell.messageLabel.text = message["text"] as! String
        print(cell.messageLabel.text)
        return cell
    }

}
