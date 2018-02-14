//
//  PaymentAmountButton.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 1/5/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import UIKit

class PaymentAmountButton: UIButton {

    let blueColor = UIColor(red: 2/255, green: 169/255, blue: 236/255, alpha: 1.0)
    
    override func awakeFromNib() {
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        self.addTarget(self, action: #selector(onPress), for: .touchUpInside)
    }
    
    @objc func onPress() {
        if self.backgroundColor != UIColor.white {
            self.backgroundColor = UIColor.white
            self.setTitleColor(blueColor, for: .normal)
        } else {
            self.backgroundColor = UIColor.clear
            self.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if self.backgroundColor != UIColor.white {
                self.backgroundColor = UIColor.white
                self.setTitleColor(blueColor, for: .normal)
            } else {
                self.backgroundColor = UIColor.clear
                self.setTitleColor(UIColor.white, for: .normal)
            }
        }
    }

}
