//
//  Robot.swift
//  GummyRobot
//
//  Created by James Birtwell on 02/08/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

import UIKit

class GummyRobot {
    var coord: MapCoord
    var alive: Bool = true
    var load: Int
    
    init(coord: MapCoord) {
        self.coord = coord
        self.load = 0
    }
}


class Store {
    var quantity: Int
    
    init(quantity: Int) {
        self.quantity = quantity
    }
    
    
}




