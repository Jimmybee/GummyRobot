//
//  Array.swift
//  GummyRobot
//
//  Created by James Birtwell on 02/08/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import UIKit

extension Array {
    func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}


extension Array where Element:UITextField {
    func addKeyboardToolBar(doneButton: UIBarButtonItem) {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(doneButton)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        forEach({$0.inputAccessoryView = doneToolbar})
    }
    
}

extension Array where Element:UITextView {
    func addKeyboardToolBar(doneButton: UIBarButtonItem) {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(doneButton)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        forEach({$0.inputAccessoryView = doneToolbar})
    }
    
}
