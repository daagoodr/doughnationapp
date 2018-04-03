//
//  BirthdayAlertView.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 3/11/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import Foundation
import UIKit

class BirthdayAlertView: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var containerView: UIView!
    
    var dateFromTextField: String?
    var delegate: BirthdayAlertViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
        datePickerValueChanged()
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setupDatePicker()
    }
    
    func setupDatePicker() {
        if let date = dateFromTextField {//string yyyy-MM-dd
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.date(from: date)!
            dateFormatter.dateFormat = "MMMM d, yyyy"
            let dateString = dateFormatter.string(from: formattedDate)
            datePicker.date = dateFormatter.date(from: dateString)!
            
        }
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        datePicker.setValue(UIColor.white, forKey: "textColor")
    }
    
    func animateView() {
        containerView.alpha = 0;
        self.containerView.frame.origin.y = self.containerView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.containerView.alpha = 1.0;
            self.containerView.frame.origin.y = self.containerView.frame.origin.y - 50
        })
    }
    
    @objc func datePickerValueChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        let date = self.datePicker.date
        self.dateLabel.text = formatter.string(from: date)
    }
    
    @IBAction func onTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapSubmitButton(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = self.datePicker.date
        delegate?.submitButtonPressed(datePickerValue: formatter.string(from: date))
        self.dismiss(animated: true, completion: nil)
    }
}
