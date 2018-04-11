//
//  CurrentUser.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 1/30/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import Foundation

class CurrentUser: NSObject, NSCoding {
    
    var id: Int
    var wePayID: Int
    var firstname: String
    var lastname: String
    var username: String
    var email: String
    var token: String
    var creditCardID: Int?
    

    
    init(id: Int, wePayID: Int, firstname: String, lastname: String, username: String, email: String, token: String) {
        self.id = id
        self.wePayID = wePayID
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
        self.email = email
        self.token = token
     }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
        let wePayID = aDecoder.decodeInteger(forKey: "wePayID")
        let firstname = aDecoder.decodeObject(forKey: "firstname") as! String
        let lastname = aDecoder.decodeObject(forKey: "lastname") as! String
        let username = aDecoder.decodeObject(forKey: "username") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let token = aDecoder.decodeObject(forKey: "token") as! String
        self.init(id: id, wePayID: wePayID, firstname: firstname, lastname: lastname, username: username, email: email, token: token)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(wePayID, forKey: "wePayID")
        aCoder.encode(firstname, forKey: "firstname")
        aCoder.encode(lastname, forKey: "lastname")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(token, forKey: "token")
    }
    
    func synchronize() {
        let encodedUser = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(encodedUser, forKey: "currentUser")
        UserDefaults.standard.synchronize()
    }
    
 
}
