//
//  MapCoord.swift
//  GummyRobot
//
//  Created by James Birtwell on 02/08/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

struct MapCoord: Hashable, Equatable {
    let x: Int
    let y: Int
    
    var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }
    
    static func == (lhs: MapCoord, rhs: MapCoord) -> Bool {
        return lhs.x == rhs.x &&
            lhs.y == rhs.y
    }
    
    func north() -> MapCoord { return MapCoord(x: x, y: y + 1)    }
    func east() -> MapCoord { return MapCoord(x: x + 1, y: y)    }
    func south() -> MapCoord { return MapCoord(x: x, y: y - 1)    }
    func west() -> MapCoord { return MapCoord(x: x - 1, y: y)    }
    
}
