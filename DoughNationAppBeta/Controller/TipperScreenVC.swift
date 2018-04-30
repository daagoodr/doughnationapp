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

class TipperScreenVC: UIViewController, TipperScreenDelegate {

    @IBOutlet weak var twoDollarButton: PaymentAmountButton!
    @IBOutlet weak var fiveDollarButton: PaymentAmountButton!
    @IBOutlet weak var tenDollarButton: PaymentAmountButton!
    @IBOutlet weak var twentyDollarButton: PaymentAmountButton!
    @IBOutlet weak var customDollarButton: PaymentAmountButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var tipButton: GradientButton!
    @IBOutlet weak var profilePicture: UIImageView!
    
    var recipName: String?
    var recipJob: String?
    var recipID: Int?
    var recipAccessToken: String?
    
    let supportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    let applePayMerchantID = "merchant.com.doughnationgifts.doughnationtips"
    
    var selectedPaymentAmount = 0
    var lastPressedButton: PaymentAmountButton?
    
    var currentUser: CurrentUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = Singleton.main.loggedInUser {
            self.currentUser = currentUser
        } else {
            //Show an error here
        }
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(selectedPaymentAmount)
    }
    
    func setupUI() {
        let bgImage = UIImageView(image: UIImage(named: "bg_base_main"))
        self.view.insertSubview(bgImage, at: 0)
        profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
        tipButton.layer.cornerRadius = tipButton.frame.height / 2
        tipButton.clipsToBounds = true
        
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
        lastPressedButton?.isSelected = false
        lastPressedButton = twoDollarButton
    }
    
    @IBAction func fiveDollarButtonPressed(sender: UIButton) {
        selectedPaymentAmount = 5
        lastPressedButton?.isSelected = false
        lastPressedButton = fiveDollarButton
    }
    
    @IBAction func tenDollarButtonPressed(sender: UIButton) {
        selectedPaymentAmount = 10
        lastPressedButton?.isSelected = false
        lastPressedButton = tenDollarButton
    }
    
    @IBAction func twentyDollarButtonPressed(sender: UIButton) {
        selectedPaymentAmount = 20
        lastPressedButton?.isSelected = false
        lastPressedButton = twentyDollarButton
    }
    
    @IBAction func customAmountButtonPressed() {
        lastPressedButton?.isSelected = false
        lastPressedButton = customDollarButton
        self.performSegue(withIdentifier: "showCustomTip", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCustomTip" {
            let vc = segue.destination as? CustomTipVC
            vc?.delegate = self
            vc?.recipID = self.recipID
            vc?.recipJob = self.recipJob
            vc?.recipName = self.recipName
        }
        
        if segue.identifier == "showCCInfo" {
            let vc = segue.destination as? CCInfoVC
            vc?.senderVC = "TipperScreenVC"
            vc?.tipAmount = selectedPaymentAmount
            vc?.recipID = self.recipID!
        }
    }
    
    @IBAction func tipSelected() {
        
        if selectedPaymentAmount == 0 {
            self.showAlert(withMessage: "Please select a payment amount")
            return
        }
        
        let paymentAlertController = UIAlertController(title: "Tip \(self.recipName!) $\(selectedPaymentAmount)", message: "", preferredStyle: .alert)
        let applePayAction = UIAlertAction(title: "Apple Pay", style: .default, handler: {(action) in
            if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: self.supportedPaymentNetworks) {
                self.payWithApplePay()
            } else {
                print("Can't use Apple Pay")
            }
        })
        
        let ccAction = UIAlertAction(title: "Credit Card", style: .default, handler: { (action) in
            if Singleton.main.loggedInUser?.creditCardID == nil || Singleton.main.loggedInUser == nil {
                self.performSegue(withIdentifier: "showCCInfo", sender: self)
            } else {
                wePayCheckoutCreate(toAccount: self.recipID!, amount: self.selectedPaymentAmount, ccID: (Singleton.main.loggedInUser?.creditCardID)!, completion: {
                    self.performSegue(withIdentifier: "unwindToScanVC", sender: self)
                })
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        paymentAlertController.addAction(ccAction)
        paymentAlertController.addAction(applePayAction)
        paymentAlertController.addAction(cancelAction)
        self.present(paymentAlertController, animated: true, completion: nil)
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
    
    func changeSelectedPaymentAmount(amount: Int) {
        self.selectedPaymentAmount = amount
    }
    
}

protocol TipperScreenDelegate {
    func changeSelectedPaymentAmount(amount: Int)
}

extension TipperScreenVC: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
