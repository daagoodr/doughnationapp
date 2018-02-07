//
//  RegisterVC.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 1/12/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import UIKit
import Alamofire

class RegisterVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func registerSelected() {
        if emailTextField.text == "" {
            let email = "test4@gmail.com"
            let parameters: Parameters = ["email":email,
                                          "password":"Thisisapassword1!"]
            
            wePayUserLogin(email: email, password: "Thisisapassword1!", completion: { (user) in
                if user.creditCardID != nil {
                    Singleton.main.loggedInUser = user
                    self.performSegue(withIdentifier: "showMain", sender: self)
                } else {
                    Singleton.main.loggedInUser = user
                    self.performSegue(withIdentifier: "showCCInfo", sender: self)
                }
            })
            
        } else {
            let email = emailTextField.text!
            let parameters: Parameters = ["firstname":"Test3",
                                          "lastname":"Test3",
                                          "email":email,
                                          "address":"123 Main St.",
                                          "mobile":"5555555555",
                                          "birthday":"1/1/11",
                                          "password":"Thisisapassword1!",
                                          "occupation":"developer",
                                          "company": "Adam's Company"]
            
            Alamofire.request("http://54.68.88.28/doughnation/api/register", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer 0d03njk30sjyc863yualz04899duhyvbahf109384udpmaqal1"]).responseString(completionHandler: { (response) in
                print(response.error)
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                self.performSegue(withIdentifier: "showMain", sender: self)
                
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
