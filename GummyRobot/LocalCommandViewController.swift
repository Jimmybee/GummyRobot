//
//  CommanController.swift
//  GummyRobot
//
//  Created by James Birtwell on 02/08/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import UIKit

/// TODO: Refactor instruction buttons to use tags and Instruction enum raw values
/// TODO: Create a location observable and bind to statusLabel and robot image

class LocalCommandViewController: UIViewController {
    
    private static var storyboardId = "LocalCommandViewController"
    
    static func storyboardInit(_ commandViewModel: LocalCommandViewModel) -> LocalCommandViewController {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let cc = mainStoryboard.instantiateViewController(withIdentifier: storyboardId)as! LocalCommandViewController
        cc.commandViewModel = commandViewModel
        return cc
    }
    
    var commandViewModel: LocalCommandViewModel!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var robotImage: UIImageView!


    override func viewDidLoad() {
        updateUI()
        
        if commandViewModel.location.robot.alive == false {
            robotImage.transform = robotImage.transform.rotated(by: CGFloat.pi / 2)
        }

    }
    
    private func updateUI() {
        statusLabel.text = commandViewModel.location.status()
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
