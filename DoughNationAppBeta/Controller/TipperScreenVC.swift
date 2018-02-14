//
//  TipperScreenVC.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 1/5/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import UIKit
import Alamofire
import PassKit

class TipperScreenVC: UIViewController {

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
    
    let supportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    let applePayMerchantID = "merchant.com.doughnationgifts.doughnationtips"
    
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
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedPaymentNetworks) {
            payWithApplePay()
        } else {
            print("Can't use Apple Pay")
        }
        /*
        let parameters: Parameters = [  "account_id": recipID,
                                        "amount": selectedPaymentAmount,
                                        "type": "donation",
                                        "currency": "USD",
                                        "short_description": "test payment",
                                        "payment_method": [
                                            "type": "credit_card",
                                            "credit_card": [
                                                "id": (Singleton.main.loggedInUser?.creditCardID)!
                                            ]
            ]
        ]
        
        Alamofire.request("https://stage.wepayapi.com/v2/checkout/create", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization":"Bearer STAGE_90cf114f6292c80093d6feb7c91e82f3f146203392f24cd823d9e1c47677a896"]).responseString(completionHandler: { (response) in
            print(response.error)
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
        })
 */
    }
    
    func payWithApplePay() {
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedPaymentNetworks) {
            let request = PKPaymentRequest()
            request.merchantIdentifier = applePayMerchantID
            request.supportedNetworks = supportedPaymentNetworks
            request.merchantCapabilities = PKMerchantCapability.capability3DS
            request.countryCode = "US"
            request.currencyCode = "USD"
            
            if let name = recipName {
                if name.components(separatedBy: " ")[1] != nil {
                    request.paymentSummaryItems = [PKPaymentSummaryItem(label: "\(name.components(separatedBy: " ")[0])", amount: NSDecimalNumber(value: selectedPaymentAmount))]
                } else {
                    request.paymentSummaryItems = [PKPaymentSummaryItem(label: "\(name)", amount: NSDecimalNumber(value: selectedPaymentAmount))]
                }
            }
            
            
            let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
            applePayController?.delegate = self
            self.present(applePayController!, animated: true, completion: nil)
        } else {
            print("Can't use Apple Pay")
        }

    }
}

extension TipperScreenVC: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
