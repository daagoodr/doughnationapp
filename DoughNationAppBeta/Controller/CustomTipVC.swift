//
//  CustomTipVC.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 2/13/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import UIKit

class CustomTipVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var customAmountField: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var tipButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var customAmountPicker: UIPickerView!
    
    var delegate: TipperScreenDelegate?
    var recipName: String?
    var recipJob: String?
    var recipID: Int?
    var recipAccessToken: String?
    
    var selectedPickerAmount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgImage = UIImageView(image: UIImage(named: "bg_base_main"))
        self.view.insertSubview(bgImage, at: 0)
        customAmountPicker.delegate = self
        customAmountPicker.dataSource = self
        profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
        profilePicture.clipsToBounds = true
        tipButton.layer.cornerRadius = tipButton.frame.height / 2
        tipButton.clipsToBounds = true
        customAmountField.delegate = self
        customAmountField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                            for: UIControlEvents.editingChanged)
        
        nameLabel.text = recipName
        
        // Do any additional setup after loading the view.
    }

    @IBAction func confirmSelected() {
        if customAmountField.text != "" && customAmountField.text != "0" {
            delegate?.changeSelectedPaymentAmount(amount: Int(customAmountField.text!)!)
            self.navigationController?.popViewController(animated: true)
        } else {
            delegate?.changeSelectedPaymentAmount(amount: selectedPickerAmount)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "0"
        }
        if textField.text != "0" && (textField.text?.hasPrefix("0"))! {
            textField.text?.remove(at: (textField.text?.startIndex)!)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 21
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        customAmountField.text = ""
        selectedPickerAmount = row
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: "$\(row)", attributes: [NSAttributedStringKey.foregroundColor: PRIMARY_BLUE])
    }
}
