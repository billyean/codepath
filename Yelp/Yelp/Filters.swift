//
//  Filters.swift
//  Yelp
//
//  Created by Yan, Tristan on 4/5/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation

class Filters {
    var offeringADeal: Bool = false
    
    var Distance: String = "Auto"
    
    var sortBy: String = "Best Match"
    
    var category: [String: Bool] = [String: Bool]()
    
    init() {
        
    }
}
