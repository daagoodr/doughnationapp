//
//  SettingsVC.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 3/19/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import Foundation
import UIKit

class SettingsVC: UIViewController {
    
    
    override func viewDidLoad() {
        self.performSegue(withIdentifier: "ShowCardInfo", sender: self)
    }
}
