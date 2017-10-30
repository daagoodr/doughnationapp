//
//  ViewController.swift
//  DoughNationAppBeta
//
//  Created by Damon Goodrich-Houska on 9/5/17.
//  Copyright © 2017 Damon Goodrich-Houska. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //connection that ties search bar in view to input for viewcontroller
   
    @IBOutlet weak var codeTextField: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func searchPressed() {
        if codeTextField.text?.count == 6 {
            print("true")
            let url = URL (string: "https://www.doughnationgifts.com/\(codeTextField.text!)")
            if #available(iOS 10.0, *)
            {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url!)
            }
        }
    }
    
    @objc func dismissKeyboard() {
        codeTextField.resignFirstResponder()
    }
}

