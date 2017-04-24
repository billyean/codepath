//
//  LoginDelegate.swift
//  TwitterRedux
//
//  Created by Yan, Tristan on 4/22/17.
//  Copyright © 2017 Yan, Tristan. All rights reserved.
//

import UIKit

protocol LoginDelegate {
    func initSign(_ loginButtonItem: UIBarButtonItem, _ tweetButtonItem: UIBarButtonItem)
    
    func login(_ buttonItem: UIBarButtonItem)
    
    func logout(_ buttonItem: UIBarButtonItem)
}

