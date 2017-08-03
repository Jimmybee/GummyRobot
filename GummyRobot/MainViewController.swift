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


// TODO: Create controlled input for crate list
// TODO: Add minus button to number pad


class MainViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let doneBarBttn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(keyboardDone))

    @IBOutlet weak var robotX: UITextField!
    @IBOutlet weak var robotY: UITextField!
    @IBOutlet weak var conveyorX: UITextField!
    @IBOutlet weak var conveyorY: UITextField!
    @IBOutlet weak var crateList: UITextView!
    @IBOutlet weak var instructions: UILabel!
    
    @IBOutlet weak var modelValidLabel: UILabel!
    @IBOutlet weak var submitCommandsBttn: UIButton!
    @IBOutlet weak var instructionStackView: UIStackView!

    var textFields: [UITextField] {
            return [robotX, robotY, conveyorX, conveyorY]
    }
    
    var textViews: [UITextView] {
        return [crateList]
    }
    
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        setupInstructionButtons()
        setupRxBinding()
    }
}

// MARK: - Setup functions
extension MainViewController {
    
    /// Adds done button to number pad keyboards
    fileprivate func setupTextFields() {
        textFields.addKeyboardToolBar(doneButton: doneBarBttn)
    }
    
    /// Sets textView delegate
    fileprivate func setupTextViews() {
        textViews.forEach({$0.delegate = self})
    }
    
    /// Adds buttons for instructions
    fileprivate func setupInstructionButtons() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        
        instructionStackView.insertArrangedSubview(stack, at: 1)
        var titles = Instruction.all.map{$0.title}
        let deleteBttn = "Del"
        titles.append(deleteBttn)
        let buttons = titles.enumerated().map { (index, element) -> UIButton in
            let button = UIButton()
            button.setTitle(element, for: .normal)
            button.backgroundColor = .lightGray
            button.tag = index
            button.addTarget(self, action: #selector(instructionBttnTapped), for: .touchUpInside)
            return button
        }
        
        buttons.forEach({ stack.addArrangedSubview($0)})
    }
    
    /// Binds textfield and textview inputs to model, and model to UI elements
    /// Binds instructions label to instructions model
    /// Binds viewModelLabe ad submitCommandsBttn to whether a model is valid
    fileprivate func setupRxBinding() {
        robotX.dualBindTo(viewModel.robotX, disposeBag: disposeBag)
        robotY.dualBindTo(viewModel.robotY, disposeBag: disposeBag)
        conveyorX.dualBindTo(viewModel.conveyorX, disposeBag: disposeBag)
        conveyorY.dualBindTo(viewModel.conveyorY, disposeBag: disposeBag)
        crateList.dualBindTo(viewModel.crateList, disposeBag: disposeBag)
        
        viewModel.instructions.asObservable()
            .map({ $0.map({$0.title})})
            .map({ $0.joined(separator: ", ")})
            .bindTo(instructions.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.modelValid.asObservable()
            .map({ $0 ? "Model Valid" : "Model Invalid"  })
            .bindTo(modelValidLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.modelValid.asObservable()
            .bindTo(submitCommandsBttn.rx.isEnabled)
            .addDisposableTo(disposeBag)
    }
}

//MARK: - UI Interactions

extension MainViewController {
    
    /// Called by Done button in toolbar added to keyboard
    func keyboardDone() {
        textFields.forEach({$0.resignFirstResponder()})
    }
    
    /// Added to instruction buttons in setupInstructionButtons
    /// Appends new instruction to model or deletes last instruction if button tag is outside range of Instructions.
    func instructionBttnTapped(_ sender: UIButton) {
        if let instruction = Instruction(rawValue: sender.tag) {
            viewModel.instructions.value.append(instruction)
        } else {
            if !viewModel.instructions.value.isEmpty {
                viewModel.instructions.value.removeLast()
            }
        }
    }
    
    /// Creates a LocalCommandViewController with location in model containing robot, conveyor, crates after instructions have been performed
    /// Pushed LocalCommandViewController on to navigation stack
    @IBAction func submitCommands() {
        let commandController = viewModel.performInstructions()
        navigationController?.pushViewController(commandController, animated: true)
    }
}

extension MainViewController: UITextViewDelegate {
    
    /// Hides keyboard on return
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}





