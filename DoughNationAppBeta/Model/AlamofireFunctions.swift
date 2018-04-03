//
//  AlamofireFunctions.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 1/30/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import Foundation
import Alamofire

struct CreditCardInfo {
    var number: String
    var cvv: String
    var expMonth: Int
    var expYear: Int
    var postalCode: String
}

func wePayCreditCardCreate(name: String, email: String, cardInfo: CreditCardInfo, completion: @escaping (Int)->()) {
    
    var parameters: Parameters?
    
        parameters = ["client_id": CLIENT_ID,
                      "user_name": name,
                      "email": email,
                      "cc_number": cardInfo.number,
                      "cvv": cardInfo.cvv,
                      "expiration_month": cardInfo.expMonth,
                      "expiration_year": cardInfo.expYear,
                      "address": [
                        "country": "US",
                        "postal_code": cardInfo.postalCode ]
        ]
    
    
    Alamofire.request("https://stage.wepayapi.com/v2/credit_card/create", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization": WEPAY_HEADER]).responseString(completionHandler: { (response) in
        print(response.error)
        print("Request: \(String(describing: response.request))")   // original url request
        print("Response: \(String(describing: response.response))") // http url response
        print("Result: \(response.result)")
        if let json = response.result.value {
            do {
                if let data = response.data, let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let id = json["credit_card_id"]  as? Int {
                        if let currentUser = Singleton.main.loggedInUser {
                            currentUser.creditCardID = id
                            print("ID: \(id)")
                            let encodedUser = NSKeyedArchiver.archivedData(withRootObject: currentUser)
                            UserDefaults.standard.set(encodedUser, forKey: "currentUser")
                            UserDefaults.standard.synchronize()
                            completion(id)
                        } else {
                            completion(id)
                        }
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

func wePayCheckoutCreate(toAccount: Int, amount: Int, ccID: Int, completion: @escaping ()->()) {
    
    let parameters: Parameters = [  "account_id": toAccount,
                                    "amount": amount,
                                    "type": "donation",
                                    "currency": "USD",
                                    "short_description": "test payment",
                                    "payment_method": [
                                        "type": "credit_card",
                                        "credit_card": [
                                            "id": ccID
                                        ]
        ]
    ]
    
    Alamofire.request("https://stage.wepayapi.com/v2/checkout/create", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization":WEPAY_HEADER]).responseString(completionHandler: { (response) in
        print(response.error)
        print("Request: \(String(describing: response.request))")   // original url request
        print("Response: \(String(describing: response.response))") // http url response
        print("Result: \(response.result)")
        do {
            if let data = response.data, let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let checkoutID = json["checkout_id"] {
                    completion()
                } else {
                    print("Card ID Error: \(json)")
                }
            }
        } catch {
            print("Error deserializing JSON: \(error)")
        }
    })
    
    
}


func doughNationUserLogin(email: String, password: String, completion: ((CurrentUser)->())?) {
    
    let parameters: Parameters = ["email":email,
                                  "password":password]
    //"https://www.doughnationgifts.com/api/login"
    Alamofire.request("http://54.68.88.28/doughnation/api/login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization": DN_HEADER]).responseString(completionHandler: { (response) in
        
        print(response.value)
        
        do {
            if let data = response.data,
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let info = json["data"] as? [String: Any] {
                let clientFirstName = info["client_firstname"] as? String ?? ""
                let clientLastName = info["client_lastname"] as? String ?? ""
                var clientUserName: String
                if !(info["client_username"] is NSNull) {
                   clientUserName = info["client_username"] as! String
                } else {
                    clientUserName = "\(clientFirstName) \(clientLastName)"
                }
                
                let clientID = info["client_id"] as? Int ?? 0
                let clientWePayID = info["wepay_account_id"] as? Int ?? 0
                let clientEmail = info["client_email"] as? String ?? ""
                let clientToken = info["client_token"] as? String ?? ""
                
                
                let currentUser = CurrentUser(id: clientID, wePayID: clientWePayID, firstname: clientFirstName, lastname: clientLastName, username: clientUserName, email: clientEmail, token: clientToken)
                Singleton.main.loggedInUser = currentUser
                let encodedUser = NSKeyedArchiver.archivedData(withRootObject: currentUser)
                UserDefaults.standard.set(encodedUser, forKey: "currentUser")
                UserDefaults.standard.set(true, forKey: "userIsLoggedIn")
                UserDefaults.standard.synchronize()
                if completion != nil { completion!(currentUser) }
            }
        } catch {
            print("Error deserializing JSON: \(error)")
        }
        
    })
}

func wePayUserLogout() {
        Alamofire.request("http://54.68.88.28/doughnation/api/logout", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": DN_HEADER]).responseString(completionHandler: { (response) in
            //Not sure how this process should work.
    })
}







