//
//  ViewController.swift
//  DoughNationAppBeta
//
//  Created by Damon Goodrich-Houska on 9/5/17.
//  Copyright © 2017 Damon Goodrich-Houska. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    //connection that ties search bar in view to input for viewcontroller
   
    @IBOutlet weak var searchbar: UISearchBar!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
    }
    //activates keyboard etc when searchbar clicked
    func searchBarSearchButtonClicked(_ searchbar: UISearchBar) {
        searchbar.resignFirstResponder()
        //(doughnationcode) is string that will equal text as entered into search bar
      
        let doughnationcode = String()
        
        searchbar.text! = doughnationcode
       
        
        guard let doughnationcode = searchbar.text else { return }
        if let url = URL (string: "https://www.doughnationgifts.com/\(doughnationcode)")
        {
           
            
            //this section to check and auto open URL in default browser "Safari"
        if #available(iOS 10.0, *)
        {
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
}

