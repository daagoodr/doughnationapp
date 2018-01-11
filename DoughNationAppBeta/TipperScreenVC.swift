//
//  TipperScreenVC.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 1/5/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import UIKit

class TipperScreenVC: UIViewController, WPTokenizationDelegate {

    @IBOutlet weak var twoDollarButton: PaymentAmountButton!
    @IBOutlet weak var fiveDollarButton: PaymentAmountButton!
    @IBOutlet weak var tenDollarButton: PaymentAmountButton!
    @IBOutlet weak var twentyDollarButton: PaymentAmountButton!
    @IBOutlet weak var customDollarButton: PaymentAmountButton!
    
    @IBOutlet weak var tipButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    
    var wePay = WePay()
    var selectedPaymentAmount = 0
    var lastPressedButton = PaymentAmountButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize WePay config with your clientId and environment
        let clientId: String = "\(CLIENT_ID)"
        let environment: String = kWPEnvironmentStage
        let accountId = ACCOUNT_ID
        let config: WPConfig = WPConfig(clientId: clientId, environment: environment)
        
        // Initialize WePay
        self.wePay = WePay(config: config)
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        profilePicture.layer.cornerRadius = profilePicture.bounds.size.width / 2
        tipButton.layer.cornerRadius = tipButton.bounds.size.width / 10
    }
    
    @IBAction func twoDollarButtonPressed(sender: UIButton) {
        selectedPaymentAmount = 2
        lastPressedButton.isSelected = false
        lastPressedButton = twoDollarButton
    }
    
    @IBAction func fiveDollarButtonPressed(sender: UIButton) {
        selectedPaymentAmount = 5
        lastPressedButton.isSelected = false
        lastPressedButton = fiveDollarButton
    }
    
    @IBAction func tenDollarButtonPressed(sender: UIButton) {
        selectedPaymentAmount = 10
        lastPressedButton.isSelected = false
        lastPressedButton = tenDollarButton
    }
    
    @IBAction func twentyDollarButtonPressed(sender: UIButton) {
        selectedPaymentAmount = 20
        lastPressedButton.isSelected = false
        lastPressedButton = twentyDollarButton
    }
    
    @IBAction func tipSelected() {
        print(selectedPaymentAmount)
        let paymentInfo: WPPaymentInfo = WPPaymentInfo(
            firstName: "WPiOS",
            lastName: "Example",
            email: "wp.ios.example@wepay.com",
            billingAddress: WPAddress(zip: "94306"),
            shippingAddress: nil,
            cardNumber: "5496198584584769",
            cvv: "123",
            expMonth: "04",
            expYear: "2020",
            virtualTerminal: true
        )
        self.wePay.tokenizePaymentInfo(paymentInfo, tokenizationDelegate: self)
    }
    
    func paymentInfo(_ paymentInfo: WPPaymentInfo!, didTokenize paymentToken: WPPaymentToken!) {
        // Send the tokenId (paymentToken.tokenId) to your server
        // Your server can use the tokenId to make a /checkout/create call to complete the transaction
        print("Transaction went through")
    }

    func paymentInfo(_ paymentInfo: WPPaymentInfo!, didFailTokenization error: Error!) {
        print(error.localizedDescription)
    }
    
}
