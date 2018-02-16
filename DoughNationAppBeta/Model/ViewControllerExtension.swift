//
//  ViewControllerExtension.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 2/15/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(withMessage: String) {
        let alert = UIAlertController(title: "Error", message: withMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
