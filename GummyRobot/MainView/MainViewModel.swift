//
//  MainViewModel.swift
//  GummyRobot
//
//  Created by James Birtwell on 03/08/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation
import RxSwift

struct MainViewModel {
    let robotX = Variable<String>("0")
    let robotY = Variable<String>("0")
    let conveyorX = Variable<String>("1")
    let conveyorY = Variable<String>("1")
    let crateList = Variable<String>("2,0,6,3,2,5")
    let instructions = Variable<[Instruction]>([.E, .E, .P, .P, .N, .W])
    
    var modelValid: Observable<Bool> {
        let robotXValid = robotX.asObservable().map({ Int($0) != nil })
        let robotYValid = robotY.asObservable().map({ Int($0) != nil })
        let conveyorXValid = conveyorX.asObservable().map({ Int($0) != nil })
        let conveyorYValid = conveyorY.asObservable().map({ Int($0) != nil })
        let crateListValid = crateList.asObservable().map({ ($0.components(separatedBy: ",").flatMap{Int($0)}.count % 3) == 0 })
        let instructionsValid = Observable.combineLatest(instructions.asObservable(), instructions.asObservable()) { $0.count == $1.count }
        return Observable.combineLatest(robotXValid, robotYValid, conveyorXValid, conveyorYValid, crateListValid, instructionsValid) { $0 && $1 && $2 && $3 && $4 && $5}
    }
    
    private func createLocation() -> Location {
        let robot = GummyRobot(coord: MapCoord(x: Int(robotX.value)!, y: Int(robotY.value)!))
        let conveyor = Conveyor(coord: MapCoord(x: Int(conveyorX.value)!, y: Int(conveyorY.value)!))
        return Location(robot: robot, conveyor: conveyor, crateInput: crateList.value)
    }
    
    func performInstructions() -> LocalCommandViewController {
        let location = createLocation()
        instructions.value.forEach({_ = $0.performAt(location: location)})
        let commandViewModel = LocalCommandViewModel(location: location)
        let commandController = LocalCommandViewController.storyboardInit(commandViewModel)
        return commandController
    }
}
