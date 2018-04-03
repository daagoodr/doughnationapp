//
//  CustomAlertViewDelegate.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 3/9/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

protocol CustomAlertViewDelegate: class {
    func submitButtonTapped(codeEntryValue: Int)
    func cancelButtonTapped()
}
