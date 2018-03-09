//
//  CCInfoVC.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 2/6/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import UIKit
import Alamofire

class CCInfoVC: UIViewController {

    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var cvvField: UITextField!
    @IBOutlet weak var expMonthField: UITextField!
    @IBOutlet weak var expYearField: UITextField!
    @IBOutlet weak var zipCodeField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addCardSelected() {
        if let currentUser = Singleton.main.loggedInUser {
            var parameters: Parameters?
            //REMOVE BEFORE GOING LIVE
            if cardNumberField.text == "" {
                parameters = ["client_id": CLIENT_ID,
                                              "user_name": currentUser.username,
                                              "email":currentUser.email,
                                              "cc_number": "5496198584584769",
                                              "cvv": "123",
                                              "expiration_month": 4,
                                              "expiration_year": 2020,
                                              "address": [
                                                "country": "US",
                                                "postal_code": "94025" ]
                ]
            } else {
                parameters = ["client_id": CLIENT_ID,
                                              "user_name": currentUser.username,
                                              "email":currentUser.email,
                                              "cc_number": cardNumberField.text!,
                                              "cvv": cvvField.text!,
                                              "expiration_month": expMonthField.text!,
                                              "expiration_year": expYearField.text!,
                                              "address": [
                                                "country": "US",
                                                "postal_code": zipCodeField.text! ]
                ]
            }
            
            //Needs Error Handling
            Alamofire.request("https://stage.wepayapi.com/v2/credit_card/create", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization": AUTH_HEADER]).responseString(completionHandler: { (response) in
                print(response.error)
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")
                if let json = response.result.value {
                    do {
                        if let data = response.data, let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                            if let id = json["credit_card_id"] {
                                currentUser.creditCardID = id as! Int
                                print("ID: \(id)")
                                let encodedUser = NSKeyedArchiver.archivedData(withRootObject: currentUser)
                                UserDefaults.standard.set(encodedUser, forKey: "currentUser")
                                UserDefaults.standard.synchronize()
                                self.performSegue(withIdentifier: "showMainVC", sender: self)
                            } else {
                                print("Card ID Error: \(json)")
                            }
                        }
                    } catch {
                        print("Error deserializing JSON: \(error)")
                    }
                }
            })
        }
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
