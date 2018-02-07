//
//  AlamofireFunctions.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 1/30/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import Foundation
import Alamofire

func createWePayCreditCard(forUser: CurrentUser, ccNumber: String, cvv: String, expMonth: Int, expYear: Int, postalCode: String) {
    
    let email = "test2email@gmail.com"
    let parameters: Parameters = ["email":email,
                                  "password":"Thisisapassword1!"]
    
    Alamofire.request("https://www.doughnationgifts.com/api/user/type/id/query/44", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer 0d03njk30sjyc863yualz04899duhyvbahf109384udpmaqal1"]).responseString(completionHandler: { (response) in
        
        do {
            if let data = response.data,
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let info = json["data"] as? [String: Any] {
                print(info)
            }
        } catch {
            print("Error deserializing JSON: \(error)")
        }
        
    })
}

func wePayUserLogin(email: String, password: String, completion: ((CurrentUser)->())?) {
    
    let parameters: Parameters = ["email":email,
                                  "password":password]
    
    Alamofire.request("http://54.68.88.28/doughnation/api/login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer 0d03njk30sjyc863yualz04899duhyvbahf109384udpmaqal1"]).responseString(completionHandler: { (response) in
        
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
                let clientEmail = info["client_email"] as? String ?? ""
                let clientToken = info["client_token"] as? String ?? ""
                
                
                let currentUser = CurrentUser(id: clientID, firstname: clientFirstName, lastname: clientLastName, username: clientUserName, email: clientEmail, token: clientToken)
                let encodedUser = NSKeyedArchiver.archivedData(withRootObject: currentUser)
                UserDefaults.standard.set(encodedUser, forKey: "currentUser")
                UserDefaults.standard.synchronize()
                if completion != nil { completion!(currentUser) }
            }
        } catch {
            print("Error deserializing JSON: \(error)")
        }
        
    })
}
