//
//  ViewController.swift
//  DoughNationAppBeta
//
//  Created by Damon Goodrich-Houska on 9/5/17.
//  Copyright © 2017 Damon Goodrich-Houska. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    //connection that ties search bar in view to input for viewcontroller
   
    @IBOutlet weak var codeTextField: UITextField!
    
    var recipName: String?
    var recipJob: String?
    var recipID: Int?
    var recipAccessToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("CC ID: \(Singleton.main.loggedInUser?.creditCardID)")
    }
    
    @IBAction func searchPressed() {
        //Not sure how to handle codes currently, can be changed
        Alamofire.request("http://54.68.88.28/doughnation/api/user/type/id/query/10", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer 0d03njk30sjyc863yualz04899duhyvbahf109384udpmaqal1"]).responseString(completionHandler: { (response) in
            
            do {
                if let data = response.data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let info = json["data"] as? [String: Any] {
                    print("JSON: \(json)")
                    if !(info["wepay_access_token"] is NSNull) {
                        self.recipAccessToken = info["wepay_access_token"] as! String
                        self.recipName = "\(info["firstname"] as! String) \(info["lastname"] as! String)"
                        self.recipJob = "\(info["occupation"] as! String), \(info["company"] as! String)"
                        self.recipID = Int(info["wepay_account_id"] as! String)
                        self.performSegue(withIdentifier: "showTipScreen", sender: self)
                    }
                    
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        })
 
    }
    
    @IBAction func cardInfo() {


    }
    
    @objc func dismissKeyboard() {
        codeTextField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTipScreen" {
            let vc = segue.destination as! TipperScreenVC
            vc.recipName = recipName!
            vc.recipJob = recipJob!
            vc.recipID = recipID!
            if let accessToken = recipAccessToken {
                vc.recipAccessToken = accessToken
            }
        }
    }
}

