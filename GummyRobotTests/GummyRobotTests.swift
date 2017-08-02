//
//  GummyRobotTests.swift
//  GummyRobotTests
//
//  Created by James Birtwell on 02/08/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import XCTest
@testable import GummyRobot

class GummyRobotTests: XCTestCase {
    
    var location: Location!
    
    override func setUp() {
        super.setUp()
        let robot = GummyRobot(coord: MapCoord(x: 0, y: 0))
        let conveyor = Conveyor(coord: MapCoord(x: 1, y: 1))
        let crateInput = "2,3,2,4,2,6"
        self.location = Location(robot: robot, conveyor: conveyor, crateInput: crateInput)
    }
    
    func testCreateCrateMap() {
        let map = location.crates
        
        XCTAssert(map.count == 2)
        let crateOneCoord = MapCoord(x: 2, y: 3)
        guard let crateOne = map[crateOneCoord] else {
            XCTFail()
            return
        }
        XCTAssert(crateOne.quantity == 2)
        
        let crateTwoCoord = MapCoord(x: 4, y: 2)
        guard let crateTwo = map[crateTwoCoord] else {
            XCTFail()
            return
        }
        XCTAssert(crateTwo.quantity == 6)
        
        let nonCrateCoord = MapCoord(x: 2, y: 6)
        XCTAssertNil(map[nonCrateCoord])
    }
    
    func testEmptyMap() {
        let map = Location.createCrateMap(input: "")
        XCTAssert(map.count == 0)
    }
    
    func testRobotMoveNorth() {
        XCTAssert(location.robot.coord.y == 0)
        _ = Instruction.N.performAt(location: location)
        XCTAssert(location.robot.coord.y == 1)
        _ = Instruction.N.performAt(location: location)
        XCTAssert(location.robot.coord.y == 2)
    }
    
    func testRobotMoveEast() {
        XCTAssert(location.robot.coord.x == 0)
        _ = Instruction.E.performAt(location: location)
        XCTAssert(location.robot.coord.x == 1)
        _ = Instruction.E.performAt(location: location)
        XCTAssert(location.robot.coord.x == 2)

    }
    
    func testRobotMoveSouth() {
        XCTAssert(location.robot.coord.y == 0)
        _ = Instruction.S.performAt(location: location)
        XCTAssert(location.robot.coord.y == -1)
        _ = Instruction.S.performAt(location: location)
        XCTAssert(location.robot.coord.y == -2)
        _ = Instruction.S.performAt(location: location)
    }
    
    func testRobotMoveWest() {
        XCTAssert(location.robot.coord.x == 0)
        _ = Instruction.W.performAt(location: location)
        XCTAssert(location.robot.coord.x == -1)
        _ = Instruction.W.performAt(location: location)
        XCTAssert(location.robot.coord.x == -2)
        _ = Instruction.W.performAt(location: location)
    }
    
    func testRoundAboutMove() {
        let instructions: [Instruction] = [.N, .E, .S, .W]
        instructions.forEach{_ = $0.performAt(location: location)}
        let startingPoint = MapCoord(x: 0, y: 0)
        XCTAssert(location.robot.coord == startingPoint)
    }
    
    func testRobotPickup() {
        let instructions: [Instruction] = [.N, .N, .N, .E, .E]
        instructions.forEach{_ = $0.performAt(location: location)}
        
        let crateOneCoord = MapCoord(x: 2, y: 3)
        XCTAssert(location.robot.coord == crateOneCoord)

        
        XCTAssert(location.robot.load == 0)
        _ = Instruction.P.performAt(location: location)
        XCTAssert(location.robot.load == 1)
        _ = Instruction.P.performAt(location: location)
        XCTAssert(location.robot.load == 2)
        _ = Instruction.P.performAt(location: location)
        XCTAssert(location.robot.load == 2)
        XCTAssert(location.robot.alive == true)
        
    }
    
    func testRobotPickupFail() {
        _ = Instruction.P.performAt(location: location)
        XCTAssert(location.robot.alive == false)
    }
    
    func testRobotDrop() {
        location.robot.load = 10
        location.robot.coord = location.conveyor.coord
        
        _ = Instruction.D.performAt(location: location)
        XCTAssert(location.conveyor.load == 10)
        XCTAssert(location.robot.load == 0)
        
        location.robot.load = 3
        _ = Instruction.D.performAt(location: location)
        XCTAssert(location.conveyor.load == 13)
        XCTAssert(location.robot.load == 0)

        XCTAssert(location.robot.alive == true)
    }
    
    
    func testRobotDropFail() {
        _ = Instruction.D.performAt(location: location)
        XCTAssert(location.robot.alive == false)
    }
    
}
