//
//  CustomTipVC.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 2/13/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import UIKit

class CustomTipVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var customAmountField: UITextField!
    
    var delegate: TipperScreenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customAmountField.delegate = self
        customAmountField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                            for: UIControlEvents.editingChanged)
        // Do any additional setup after loading the view.
    }

    @IBAction func confirmSelected() {
        if customAmountField.text != "" {
            delegate?.changeSelectedPaymentAmount(amount: Int(customAmountField.text!)!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "0"
        }
        if textField.text != "0" && (textField.text?.hasPrefix("0"))! {
            textField.text?.remove(at: (textField.text?.startIndex)!)
        }
    }
    
    
}
