//
//  GradientButton.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 3/11/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import Foundation

class GradientButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.orange.cgColor, UIColor.yellow.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
}
