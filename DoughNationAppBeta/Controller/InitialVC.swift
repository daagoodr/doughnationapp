//
//  InitialVC.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 3/19/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import UIKit

class InitialVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "userIsLoggedIn") == false {
            self.performSegue(withIdentifier: "ShowLoginScreen", sender: self)
        } else {
            if let data = UserDefaults.standard.data(forKey: "currentUser"), let currentUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? CurrentUser {
                Singleton.main.loggedInUser = currentUser
                print("Current User: \(currentUser)")
                currentUser.getTransactionHistory()
                self.performSegue(withIdentifier: "ShowMainScreen", sender: self)
            }
            
        }

    }

}
