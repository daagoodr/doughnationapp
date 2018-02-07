//
//  PaymentAmountButton.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 1/5/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import UIKit

class PaymentAmountButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        self.addTarget(self, action: #selector(onPress), for: .touchUpInside)
    }
    
    @objc func onPress() {
        if self.backgroundColor != UIColor.white {
            self.backgroundColor = UIColor.white
        } else {
            self.backgroundColor = UIColor.clear
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if self.backgroundColor != UIColor.white {
                self.backgroundColor = UIColor.white
            } else if self.backgroundColor == UIColor.white {
                self.backgroundColor = UIColor.clear
            }
        }
    
        
    }

}
