//
//  Location.swift
//  GummyRobot
//
//  Created by James Birtwell on 02/08/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

typealias CrateMap = [MapCoord: Store]

struct Location {
    let robot: GummyRobot
    let conveyor: Conveyor
    let crates: CrateMap
    
    init(robot: GummyRobot, conveyor: Conveyor, crateInput: String) {
        self.robot = robot
        self.conveyor = conveyor
        self.crates = Location.createCrateMap(input: crateInput)
    }
    
    func status() -> String {
        let robotPoint = ("Robot: \(robot.coord) \n")
        let statusMessage = robot.alive ? "still functioning" : "short circuited"
        let robotAlive = ("Status: \(statusMessage) \n")
        let robotLoad = ("Robot load: \(robot.load) \n")
        let conveyorLoad = ("Conveyor load: \(conveyor.load) \n")
        return robotPoint + robotAlive + robotLoad + conveyorLoad
    }
    
    static func createCrateMap(input: String) -> CrateMap {
        let split = input.components(separatedBy: ",").flatMap{Int($0)}.chunks(3)
        return split.reduce(CrateMap()) { (result, crateSplit) -> CrateMap in
            let point = MapCoord(x: crateSplit[0], y:  crateSplit[1])
            let crate = Store(quantity: crateSplit[2])
            var dict = result
            dict[point] = crate
            return dict
        }
    }
    
    
}
