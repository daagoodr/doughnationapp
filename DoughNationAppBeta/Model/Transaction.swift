//
//  Transaction.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 4/30/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import Foundation

struct Transaction {
    var recipient_firstname: String
    var recipient_lastname: String
    var recipient_user_id: Int
    var status: Any
    var tipper_firstname: String
    var tipper_lastname: String
    var tipper_user_id: Int
    var transaction_amount: Int
    var transaction_app_fee: Double
    var transaction_checkout_id: String
    var transaction_date: String
    var transaction_time: String
    var transaction_id: Int
    var transaction_notes: Any
    var transaction_number: String
    
}

extension Transaction {
    init?(json: [String: Any]) {
        guard let recipient_firstname = json["recipient_firstname"] as? String,
        let recipient_lastname = json["recipient_lastname"] as? String,
        let recipient_user_id = json["recipient_user_id"] as? Int,
        let status = json["status"],
        let tipper_firstname = json["tipper_firstname"] as? String,
        let tipper_lastname = json["tipper_lastname"] as? String,
        let tipper_user_id = json["tipper_user_id"] as? Int,
        let transaction_amount = json["transaction_amount"] as? Int,
        let transaction_app_fee = json["transaction_app_fee"] as? Double,
        let transaction_checkout_id = json["transaction_checkout_id"] as? String,
        let transaction_date = json["transaction_date"] as? String,
        let transaction_id = json["transaction_id"] as? Int,
        let transaction_notes = json["transaction_notes"],
        let transaction_number = json["transaction_number"] as? String else {
                return nil
        }
        
        self.recipient_firstname = recipient_firstname
        self.recipient_lastname = recipient_lastname
        self.recipient_user_id = recipient_user_id
        self.status = status
        self.tipper_firstname = tipper_firstname
        self.tipper_lastname = tipper_lastname
        self.tipper_user_id = tipper_user_id
        self.transaction_amount = transaction_amount
        self.transaction_app_fee = transaction_app_fee
        self.transaction_checkout_id = transaction_checkout_id
        let dateAndTime = transaction_date.components(separatedBy: " ")
        self.transaction_date = dateAndTime[0]
        self.transaction_time = dateAndTime[1]
        self.transaction_id = transaction_id
        self.transaction_notes = transaction_notes
        self.transaction_number = transaction_number
        
    }
}
