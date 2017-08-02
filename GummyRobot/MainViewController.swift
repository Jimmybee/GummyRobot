//
//  ViewController.swift
//  GummyRobot
//
//  Created by James Birtwell on 02/08/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let doneBarBttn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(keyboardDone))

    @IBOutlet weak var robotX: UITextField!
    @IBOutlet weak var robotY: UITextField!
    @IBOutlet weak var conveyorX: UITextField!
    @IBOutlet weak var conveyorY: UITextField!
    @IBOutlet weak var crateList: UITextView!
    @IBOutlet weak var instructions: UITextView!
    
    @IBOutlet weak var modelValidLabel: UILabel!
    @IBOutlet weak var submitCommandsBttn: UIButton!


    var textFields: [UITextField] {
            return [robotX, robotY, conveyorX, conveyorY]
    }
    
    var textViews: [UITextView] {
        return [crateList, instructions]
    }
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFields.addKeyboardToolBar(doneButton: doneBarBttn)
        textViews.forEach({$0.delegate = self})
        bindModel()
    }
    
    func bindModel() {
        robotX.dualBindTo(viewModel.robotX, disposeBag: disposeBag)
        robotY.dualBindTo(viewModel.robotY, disposeBag: disposeBag)
        conveyorX.dualBindTo(viewModel.conveyorX, disposeBag: disposeBag)
        conveyorY.dualBindTo(viewModel.conveyorY, disposeBag: disposeBag)
        crateList.dualBindTo(viewModel.crateList, disposeBag: disposeBag)
        instructions.dualBindTo(viewModel.instructions, disposeBag: disposeBag)
        
        viewModel.modelValid.asObservable()
            .map({ $0 ? "Model Valid" : "Model Invalid"  })
            .bindTo(modelValidLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.modelValid.asObservable()
            .bindTo(submitCommandsBttn.rx.isEnabled)
            .addDisposableTo(disposeBag)
    }

    @IBAction func submitCommands() {
        let commandController = viewModel.performInstructions()
        navigationController?.pushViewController(commandController, animated: true)
    }
    
    func keyboardDone() {
        textFields.forEach({$0.resignFirstResponder()})
    }
}

extension MainViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

struct MainViewModel {
    let robotX = Variable<String>("0")
    let robotY = Variable<String>("0")
    let conveyorX = Variable<String>("1")
    let conveyorY = Variable<String>("1")
    let crateList = Variable<String>("2,0,6,3,2,5")
    let instructions = Variable<String>("EEPPNW")
    
    private var instructionList: Observable<[Instruction]> {
        return instructions.asObservable()
            .map{ ($0.characters) }
            .map{ $0.flatMap({Instruction(rawValue: String($0))}) }
    }
    
    
    var modelValid: Observable<Bool> {
        let robotXValid = robotX.asObservable().map({ Int($0) != nil })
        let robotYValid = robotY.asObservable().map({ Int($0) != nil })
        let conveyorXValid = conveyorX.asObservable().map({ Int($0) != nil })
        let conveyorYValid = conveyorY.asObservable().map({ Int($0) != nil })
        let crateListValid = crateList.asObservable().map({ ($0.components(separatedBy: ",").flatMap{Int($0)}.count % 3) == 0 })
        let instructionsValid = Observable.combineLatest(instructions.asObservable(), instructionList) { $0.characters.count == $1.count }
        
        return Observable.combineLatest(robotXValid, robotYValid, conveyorXValid, conveyorYValid, crateListValid, instructionsValid) { $0 && $1 && $2 && $3 && $4 && $5}
    }
    
    private func createLocation() -> Location {
        let robot = GummyRobot(coord: MapCoord(x: Int(robotX.value)!, y: Int(robotY.value)!))
        let conveyor = Conveyor(coord: MapCoord(x: Int(conveyorX.value)!, y: Int(conveyorY.value)!))
        return Location(robot: robot, conveyor: conveyor, crateInput: crateList.value)
    }
    
    func performInstructions() -> CommandController {
        let location = createLocation()
        instructions.value.characters.flatMap({Instruction(rawValue: String($0))}).forEach({_ = $0.performAt(location: location)})
        let commandViewModel = CommandViewModel(location: location)
        let commandController = CommandController.storyboardInit(commandViewModel)
        return commandController
    }
}



extension UITextField {
    func dualBindTo(_ modelVariable: Variable<String>, disposeBag: DisposeBag) {
        modelVariable.asObservable()
            .bindTo(self.rx.text)
            .addDisposableTo(disposeBag)
        
        self.rx.text
            .orEmpty
            .bindTo(modelVariable)
            .addDisposableTo(disposeBag)
    }
}

extension UITextView {
    func dualBindTo(_ modelVariable: Variable<String>, disposeBag: DisposeBag) {
        modelVariable.asObservable()
            .bindTo(self.rx.text)
            .addDisposableTo(disposeBag)
        
        self.rx.text
            .orEmpty
            .bindTo(modelVariable)
            .addDisposableTo(disposeBag)
    }
}

