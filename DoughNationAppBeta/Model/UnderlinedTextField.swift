//
//  UnderlinedTextField.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 3/10/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import Foundation
import UIKit

class UnderlinedTextField: UITextField, UITextFieldDelegate {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createUnderLine()
    }
    func createUnderLine() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
