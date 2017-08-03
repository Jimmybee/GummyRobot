//
//  Instruction.swift
//  GummyRobot
//
//  Created by James Birtwell on 02/08/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

enum Instruction: Int {
    case  N, E, S, W, P, D
    
    /// Updates a location with a performed action
    /// N: Moves robot north
    /// E: Moves robot east
    /// S: Moves robot south
    /// W: Moves robot west
    /// P: Pickups up any bags at robot location in crate, and kills robot when no create exists
    /// D: Drops robot bag load at conveyor if at same location, and kills robot if not at conveyor
    /// - parameter location: A location containing a robot, conveyor and list of crates
    /// - returns: A InstructionResult containing the success or failure
    func performAt(location: Location) -> InstructionResult {
        guard location.robot.alive == true else { return InstructionResult.fail(.brownBread)  }
        let robot = location.robot
        switch self {
        case .P:
            guard let crate = location.crates[robot.coord] else {
                robot.alive = false
                return InstructionResult.fail(.justFell)
            }
            guard crate.quantity > 0 else { return InstructionResult.fail(.unableToComplete) }
            crate.quantity -= 1
            robot.load += 1
            return InstructionResult.success
        case .D:
            guard robot.coord == location.conveyor.coord else {
                robot.alive = false
                return InstructionResult.fail(.justFell)
            }
            location.conveyor.load += robot.load
            robot.load = 0
            return InstructionResult.success
        case .N:
            robot.coord = robot.coord.north()
            return InstructionResult.success
        case .E:
            robot.coord = robot.coord.east()
            return InstructionResult.success
        case .S:
            robot.coord = robot.coord.south()
            return InstructionResult.success
        case .W:
            robot.coord = robot.coord.west()
            return InstructionResult.success
        }
    }
    
    static var all: [Instruction] {
        return [.N, .E, .S, .W, .P, .D]
    }
    
    var title: String {
        switch self {
        case .P:
            return "P"
        case .D:
            return "D"
        case .N:
            return "N"
        case .E:
            return "E"
        case .S:
            return "S"
        case .W:
            return "W"
        }
    }
}

enum InstructionResult {
    case success
    case fail(FailType)
}

enum FailType {
    case brownBread
    case justFell
    case unableToComplete
    case unknown
}
