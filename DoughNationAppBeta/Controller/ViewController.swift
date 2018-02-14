//
//  ViewController.swift
//  DoughNationAppBeta
//
//  Created by Damon Goodrich-Houska on 9/5/17.
//  Copyright © 2017 Damon Goodrich-Houska. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    //connection that ties search bar in view to input for viewcontroller
   
    @IBOutlet weak var codeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("CC ID: \(Singleton.main.loggedInUser?.creditCardID)")
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
    
    @IBAction func cardInfo() {


    }
    
    @objc func dismissKeyboard() {
        codeTextField.resignFirstResponder()
    }
}

