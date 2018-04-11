//
//  CCInfoVC.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 2/6/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import UIKit
import Alamofire
import TextFieldEffects

class CCInfoVC: UIViewController {

    
    @IBOutlet weak var firstNameField: HoshiTextField!
    @IBOutlet weak var lastNameField: HoshiTextField!
    @IBOutlet weak var emailField: HoshiTextField!
    @IBOutlet weak var addressField: HoshiTextField!
    @IBOutlet weak var postalCodeField: HoshiTextField!
    @IBOutlet weak var creditCardNumField: HoshiTextField!
    @IBOutlet weak var cvvField: HoshiTextField!
    @IBOutlet weak var monthExpiryField: HoshiTextField!
    @IBOutlet weak var yearExpiryField: HoshiTextField!
    
    @IBOutlet weak var payButton: GradientButton!
    
    var senderVC: String?
    var tipAmount: Int?
    var recipID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payButton.layer.cornerRadius = payButton.frame.height / 2
        payButton.clipsToBounds = true
        
        if senderVC == "TipperScreenVC" {
            self.payButton.setTitle("PAY", for: .normal)
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func paySelected() {
        var cardInfo: CreditCardInfo?
        if creditCardNumField.text == "" {
            cardInfo = CreditCardInfo(number: "4111111111111111", cvv: "123", expMonth: 01, expYear: 2020, postalCode: "90210")
        } else {
            cardInfo = CreditCardInfo(number: creditCardNumField.text!, cvv: cvvField.text!, expMonth: Int(monthExpiryField.text!)!, expYear: Int(yearExpiryField.text!)!, postalCode: postalCodeField.text!)
        }
        let name = "\(self.firstNameField.text!) \(self.lastNameField.text!)"
        let email = self.emailField.text!
        //wePayCreditCardCreate(name: name, email: email, cardInfo: cardInfo!, completion: {(cardID) in
        wePayCreditCardCreate(name: "Test User", email: "test11@gmail.com", cardInfo: cardInfo!, completion: {(cardID) in
            if self.senderVC == "TipperScreenVC" && self.tipAmount != nil {
                wePayCheckoutCreate(toAccount: self.recipID!, amount: self.tipAmount!, ccID: cardID, completion: {
                    if Singleton.main.loggedInUser != nil {
                        let alertController = UIAlertController(title: "Thanks for the tip!", message: "Would you like to save this card?", preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: "Sure!", style: .default, handler: {(action) in
                            Singleton.main.loggedInUser!.creditCardID = cardID
                            Singleton.main.loggedInUser!.synchronize()
                        })
                        let denyAction = UIAlertAction(title: "No Thanks", style: .default, handler: {(action) in
                            self.performSegue(withIdentifier: "unwindToScanVC", sender: self)
                        })
                        alertController.addAction(confirmAction)
                        alertController.addAction(denyAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                    } else {
                        Singleton.main.guestCCID = cardID
                        let alertController = UIAlertController(title: "Thanks for the tip!", message: "Would you like to create an account?", preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: "Sure!", style: .default, handler: {(action) in
                            self.performSegue(withIdentifier: "unwindToRegisterVC", sender: self)
                        })
                        let denyAction = UIAlertAction(title: "No Thanks", style: .default, handler: {(action) in
                            self.performSegue(withIdentifier: "unwindToLoginVC", sender: self)
                        })
                        alertController.addAction(confirmAction)
                        alertController.addAction(denyAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                })
            }
        })
    }
    
    @IBAction func addCardSelected() {
        var cardInfo: CreditCardInfo?
        if creditCardNumField.text == "" {
            cardInfo = CreditCardInfo(number: "4111111111111111", cvv: "123", expMonth: 01, expYear: 2020, postalCode: "90210")
        } else {
            cardInfo = CreditCardInfo(number: creditCardNumField.text!, cvv: cvvField.text!, expMonth: Int(monthExpiryField.text!)!, expYear: Int(yearExpiryField.text!)!, postalCode: postalCodeField.text!)
        }
        //wePayCreditCardCreate(name: "\(firstNameField.text!) \(lastNameField.text!)", email: emailField.text!, cardInfo: cardInfo!, completion: {(cardID) in
        wePayCreditCardCreate(name: "Test User", email: "test11@gmail.com", cardInfo: cardInfo!, completion: {(cardID) in
            if self.senderVC == "TipperScreenVC" && self.tipAmount != nil {
                wePayCheckoutCreate(toAccount: self.recipID!, amount: self.tipAmount!, ccID: cardID, completion: {
                    if Singleton.main.loggedInUser != nil {
                        let alertController = UIAlertController(title: "Thanks for the tip!", message: "Would you like to save this card?", preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: "Sure!", style: .default, handler: {(action) in
                            let name = "\(self.firstNameField.text!) \(self.lastNameField.text!)"
                            let email = self.emailField.text!
                            wePayCreditCardCreate(name: name, email: email, cardInfo: cardInfo!, completion: {(cardID) in
                                Singleton.main.loggedInUser!.creditCardID = cardID
                                
                            })
                        })
                        let denyAction = UIAlertAction(title: "No Thanks", style: .default, handler: {(action) in
                            self.performSegue(withIdentifier: "unwindToLoginVC", sender: self)
                        })
                        alertController.addAction(confirmAction)
                        alertController.addAction(denyAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        self.performSegue(withIdentifier: "unwindToScanVC", sender: self)
                    } else {
                        let alertController = UIAlertController(title: "Thanks for the tip!", message: "Would you like to create an account?", preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: "Sure!", style: .default, handler: {(action) in
                            self.performSegue(withIdentifier: "unwindToRegisterVC", sender: self)
                        })
                        let denyAction = UIAlertAction(title: "No Thanks", style: .default, handler: {(action) in
                            self.performSegue(withIdentifier: "unwindToLoginVC", sender: self)
                        })
                        alertController.addAction(confirmAction)
                        alertController.addAction(denyAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                   
                })
            }
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
