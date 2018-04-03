//
//  BirthdayAlertViewDelegate.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 3/11/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

protocol BirthdayAlertViewDelegate: class {
    func submitButtonPressed(datePickerValue: String)
}
