//
//  TipperScreenVC.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 1/5/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import UIKit
import Alamofire

class TipperScreenVC: UIViewController, WPTokenizationDelegate {

    @IBOutlet weak var twoDollarButton: PaymentAmountButton!
    @IBOutlet weak var fiveDollarButton: PaymentAmountButton!
    @IBOutlet weak var tenDollarButton: PaymentAmountButton!
    @IBOutlet weak var twentyDollarButton: PaymentAmountButton!
    @IBOutlet weak var customDollarButton: PaymentAmountButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var tipButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    
    var recipName: String?
    var recipJob: String?
    var recipID: Int?
    var recipAccessToken: String?
    
    var selectedPaymentAmount = 0
    var lastPressedButton = PaymentAmountButton()
    
    var currentUser: CurrentUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = Singleton.main.loggedInUser {
            self.currentUser = currentUser
        } else {
            //Show an error here
        }
        
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    
    func setupUI() {
        profilePicture.layer.cornerRadius = profilePicture.bounds.size.width / 2
        tipButton.layer.cornerRadius = tipButton.bounds.size.width / 10
        if let name = recipName {
            nameLabel.text = name
            if name.components(separatedBy: " ")[1] != nil {
                tipButton.setTitle("Tip \(name.components(separatedBy: " ")[0])", for: .normal)
            } else {
                tipButton.setTitle("Tip \(name)", for: .normal)
            }
        }
        if let job = recipJob {
            jobLabel.text = job
        }
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
        
        let parameters: Parameters = [  "account_id": recipID,
                                        "amount": selectedPaymentAmount,
                                        "type": "donation",
                                        "currency": "USD",
                                        "short_description": "test payment",
                                        "payment_method": [
                                            "type": "credit_card",
                                            "credit_card": [
                                                "id": Singleton.main.loggedInUser?.creditCardID!
                                            ]
            ]
        ]
        
        Alamofire.request("https://stage.wepayapi.com/v2/checkout/create", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization":"Bearer \(self.recipAccessToken!)"]).responseString(completionHandler: { (response) in
            print(response.error)
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
        })
        
        
        
        
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
