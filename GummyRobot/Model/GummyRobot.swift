//
//  Robot.swift
//  GummyRobot
//
//  Created by James Birtwell on 02/08/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

class GummyRobot {
    var coord: MapCoord
    var alive: Bool = true
    var load: Int
    
    init(coord: MapCoord) {
        self.coord = coord
        self.load = 0
    }
}







