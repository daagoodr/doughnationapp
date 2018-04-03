//
//  CustomAlertView.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 3/9/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import UIKit
import CBPinEntryView

class CustomAlertView: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var codeEntryView: CBPinEntryView!
    
    var delegate: CustomAlertViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeEntryView.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        codeEntryView.entryBackgroundColour = UIColor.lightGray.withAlphaComponent(0.5)
        codeEntryView.entryBorderColour = PRIMARY_BLUE
        codeEntryView.entryBorderWidth = 2.0
        codeEntryView.entryFont = UIFont.systemFont(ofSize: 29)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    @IBAction func onTapCancelButton(_ sender: Any) {
        codeEntryView.resignFirstResponder()
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapSubmitButton(_ sender: Any) {
        codeEntryView.resignFirstResponder()
        guard let codeEntry = codeEntryView.getPinAsInt() else { return }
        self.dismiss(animated: true) {
            self.delegate?.submitButtonTapped(codeEntryValue: codeEntry)
        }
    }

}
