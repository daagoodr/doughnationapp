//
//  Singleton.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 2/6/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import Foundation

class Singleton {
    
    static var main = Singleton()
    
    var loggedInUser: CurrentUser?
    
    var guestCCID: Int?
}
