//
//  CommanController.swift
//  GummyRobot
//
//  Created by James Birtwell on 02/08/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import UIKit

class CommandController: UIViewController {
    
    private static var storyboardId = "CommandController"
    
    static func storyboardInit(_ commandViewModel: CommandViewModel) -> CommandController {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let cc = mainStoryboard.instantiateViewController(withIdentifier: storyboardId)as! CommandController
        cc.commandViewModel = commandViewModel
        return cc
    }
    
    var commandViewModel: CommandViewModel!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var robotImage: UIImageView!

    func updateUI() {
        statusLabel.text = commandViewModel.location.status()
    }
    
    override func viewDidLoad() {
        updateUI()
    }
    
    @IBAction func moveNorth() {
        _ = Instruction.N.performAt(location: commandViewModel.location)
        updateUI()
    }
    
    @IBAction func moveEast() {
        _ = Instruction.E.performAt(location: commandViewModel.location)
        updateUI()
    }
    
    @IBAction func moveSouth() {
        _ = Instruction.S.performAt(location: commandViewModel.location)
        updateUI()
    }
    
    @IBAction func moveWest() {
        _ = Instruction.W.performAt(location: commandViewModel.location)
        updateUI()
    }
    
    @IBAction func pickUp() {
        let result = Instruction.P.performAt(location: commandViewModel.location)
        updateImage(result)
        updateUI()
    }
    
    @IBAction func drop() {
        let result = Instruction.D.performAt(location: commandViewModel.location)
        updateImage(result)
        updateUI()
    }
    
    private func updateImage(_ result: InstructionResult) {
        switch result {
        case .fail(let type):
            if type == .justFell {
                robotImage.transform = robotImage.transform.rotated(by: CGFloat.pi / 2)
            }
        default:
            break
        }
    }
}

struct CommandViewModel {
    var location: Location
    
    init(location: Location) {
        self.location = location
    }
}
