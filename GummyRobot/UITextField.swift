//
//  UITextField.swift
//  GummyRobot
//
//  Created by James Birtwell on 03/08/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

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
