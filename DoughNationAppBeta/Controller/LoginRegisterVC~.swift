//
//  RegisterVC.swift
//  DoughNationAppBeta
//
//  Created by Adam P Dostalik on 1/12/18.
//  Copyright © 2018 Damon Goodrich-Houska. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import HMSegmentedControl
import M13Checkbox

class LoginRegisterVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate, UIScrollViewDelegate {

    @IBOutlet weak var scannerView: UIView!
    @IBOutlet weak var scannerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var registerScrollView: UIScrollView!
    @IBOutlet weak var registerInfoView: UIView!
    @IBOutlet weak var segmentedControl: HMSegmentedControl!
    
    @IBOutlet weak var manualCodeEntryButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginEmailField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    
    @IBOutlet weak var firstNameField: UnderlinedTextField!
    @IBOutlet weak var lastNameField: UnderlinedTextField!
    @IBOutlet weak var usernameField: UnderlinedTextField!
    @IBOutlet weak var registerEmailField: UnderlinedTextField!
    @IBOutlet weak var registerPasswordField: UnderlinedTextField!
    @IBOutlet weak var confirmPasswordField: UnderlinedTextField!
    @IBOutlet weak var mobileNumberField: UnderlinedTextField!
    @IBOutlet weak var birthdayField: UnderlinedTextField!
    @IBOutlet weak var addressField: UnderlinedTextField!
    @IBOutlet weak var cityField: UnderlinedTextField!
    @IBOutlet weak var stateField: UnderlinedTextField!
    @IBOutlet weak var zipCodeField: UnderlinedTextField!
    @IBOutlet weak var companyField: UnderlinedTextField!
    @IBOutlet weak var occupationField: UnderlinedTextField!
    @IBOutlet weak var checkbox1: M13Checkbox!
    @IBOutlet weak var checkbox2: M13Checkbox!
    
    
    var videoCaptureDevice: AVCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)!
    var device = AVCaptureDevice.default(for: AVMediaType.video)
    var output = AVCaptureMetadataOutput()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var captureSession = AVCaptureSession()
    var code: String?
    
    var scannedCode = UILabel()
    var recipName: String?
    var recipJob: String?
    var recipID: Int?
    var recipAccessToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkbox1.boxType = .square
        checkbox1.stateChangeAnimation = .fill
        checkbox2.boxType = .square
        checkbox2.stateChangeAnimation = .fill
        
        manualCodeEntryButton.layer.cornerRadius = manualCodeEntryButton.frame.width / 2
        manualCodeEntryButton.imageEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
        self.setupCamera()
        
        loginEmailField.delegate = self
        loginPasswordField.delegate = self
        birthdayField.delegate = self
        registerScrollView.delegate = self

        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.clipsToBounds = true
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
        registerButton.clipsToBounds = true
    }
    
    override func viewDidLayoutSubviews() {

        segmentedControl.sectionTitles = ["LOGIN", "REGISTER"]
        segmentedControl.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.gray]
        segmentedControl.selectedTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 15/255, green: 144/255, blue: 209/255, alpha: 1.0)]
        segmentedControl.selectionIndicatorColor = UIColor(red: 15/255, green: 144/255, blue: 209/255, alpha: 1.0)
        segmentedControl.selectionIndicatorLocation = .down
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if (captureSession.isRunning == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        if (captureSession.isRunning == true) {
            captureSession.stopRunning();
        }
    }
    
    @IBAction func loginSelected() {
        doughNationUserLogin(email: loginEmailField.text!, password: loginPasswordField.text!, completion: { (user) in
            self.performSegue(withIdentifier: "showMain", sender: self)
        })
    }
    
    @IBAction func registerSelected() {
        let email = registerEmailField.text!
        let password = registerPasswordField.text!
        let testParameters: Parameters = ["firstname":"Test",
                                      "lastname":"Test",
                                      "email":email,
                                      "address":"111 Main St.",
                                      "mobile":"5555555555",
                                      "birthday":"1/1/11",
                                      "password":"Password1!",
                                      "occupation":"test occupation",
                                      "company": "test company"]
        /*
        let parameters: Parameters = ["firstname":firstNameField.text!,
                                      "lastname":lastNameField.text!,
                                      "email":email,
                                      "address":addressField.text!,
                                      "mobile":mobileNumberField.text!,
                                      "birthday":birthdayField.text!,
                                      "password":password,
                                      "occupation":occupationField.text!,
                                      "company": companyField.text!]
        */
        
        //"https://www.doughnationgifts.com/api/register"
        Alamofire.request("http://54.68.88.28/doughnation/api/register", method: .post, parameters: testParameters, encoding: JSONEncoding.default, headers: ["Authorization": DN_HEADER]).responseString(completionHandler: { (response) in
            
            guard let statusCode = response.response?.statusCode else { return }
            if statusCode == 200 {
                doughNationUserLogin(email: email, password: password, completion: { (currentUser) in
                    if let cardID = Singleton.main.guestCCID {
                        currentUser.creditCardID = cardID
                        currentUser.synchronize()
                    }
                })
                self.performSegue(withIdentifier: "showMain", sender: self)
            } else {
                self.showAlert(withMessage: response.result.value!)
            }
            
            
        })
    }
    
    @IBAction func manualCodeEntrySelected() {
        if (captureSession.isRunning == true) {
            captureSession.stopRunning();
        }
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertView") as! CustomAlertView
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        customAlert.delegate = self
        self.present(customAlert, animated: true, completion: nil)
    }
    
    @IBAction func unwindToRegisterVC(segue: UIStoryboardSegue) {
        self.segmentedControl.setSelectedSegmentIndex(1, animated: false)
        loginView.isHidden = true
        registerInfoView.isHidden = false
    }
    
    @IBAction func unwindToLoginVC(segue: UIStoryboardSegue) {}
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // This is the delegate'smethod that is called when a code is readed
        
        print(metadataObjects)
        for metadata in metadataObjects {
            let readableObject = metadata as! AVMetadataMachineReadableCodeObject
            if let components = readableObject.stringValue?.components(separatedBy: ",") {
                if components[1] != nil {
                    Alamofire.request("https://doughnationgifts.com/api/user/type/code/query/\(components[1])", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": DN_HEADER]).responseString(completionHandler: { (response) in
                        
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
                                
                            } else {
                                print("JSON: \(try JSONSerialization.jsonObject(with: response.data!) as? [String: Any])")
                            }
                        } catch {
                            print("Error deserializing JSON: \(error)")
                        }
                    })
                    
                }
                
            } else {
                let alertController = UIAlertController(title: "Error", message: "Invalid code, please try again", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    private func setupCamera() {
        
        let input = try? AVCaptureDeviceInput(device: videoCaptureDevice)
        
        if self.captureSession.canAddInput(input!) {
            self.captureSession.addInput(input!)
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        if let videoPreviewLayer = self.previewLayer {
            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer.frame = scannerView.frame
            //view.layer.addSublayer(videoPreviewLayer)
            scannerView.layer.addSublayer(videoPreviewLayer)
            
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if self.captureSession.canAddOutput(metadataOutput) {
            self.captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } else {
            print("Could not add metadata output")
        }
    }
    
    @objc func segmentedControlChanged() {
        loginView.isHidden = !(loginView.isHidden)
        registerInfoView.isHidden = !(registerInfoView.isHidden)
        registerScrollView.isScrollEnabled = !(registerScrollView.isScrollEnabled)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 7 {
            textField.endEditing(true)
            let birthdayAlert = self.storyboard?.instantiateViewController(withIdentifier: "BirthdayAlertView") as! BirthdayAlertView
            birthdayAlert.providesPresentationContextTransitionStyle = true
            birthdayAlert.definesPresentationContext = true
            birthdayAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            birthdayAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            if birthdayField.text != "" {
                birthdayAlert.dateFromTextField = birthdayField.text!
            }
            birthdayAlert.delegate = self
            self.present(birthdayAlert, animated: true, completion: nil)
        }
    }
    
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scannerViewPosition = scannerView.frame
        let container = CGRect(x: registerScrollView.contentOffset.x, y: registerScrollView.contentOffset.y, width: registerScrollView.frame.size.width, height: registerScrollView.frame.size.height)
        if scannerViewPosition.intersects(container) {
            if scannerViewPosition.union(container).height > 900.0 {
                //Show the blue top bar, scroll only the text fields
            }
        }
    }
*/
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

extension LoginRegisterVC: CustomAlertViewDelegate {
    
    func submitButtonTapped(codeEntryValue: Int) {
        print("Entry Code Value is \(codeEntryValue)")
        
        Alamofire.request("http://54.68.88.28/doughnation/api/user/type/id/query/\(codeEntryValue)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": DN_HEADER]).responseString(completionHandler: { (response) in
            
            do {
                if let data = response.data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let info = json["data"] as? [String:Any] {
                    print(info)
                    self.recipName = "\(info["firstname"] as? String ?? "First Name") \(info["lastname"] as? String ?? "Last Name")"
                    self.recipJob = "\(info["occupation"] as? String ?? "N/A"), \(info["company"] as? String ?? "N/A")"
                    guard let accountID = info["wepay_account_id"] as? String else { return }
                    self.recipID = Int(accountID)
                    self.performSegue(withIdentifier: "showTipScreen", sender: self)
                    
                    
                } else {
                    print("JSON: \(try JSONSerialization.jsonObject(with: response.data!) as? [String: Any])")
                }
            } catch {
                print("Error deserializing JSON: \(error)")
            }
        })
        
        if (captureSession.isRunning == false) {
            captureSession.startRunning();
        }
    }
    
    func cancelButtonTapped() {
        print("cancelButtonTapped")
        if (captureSession.isRunning == false) {
            captureSession.startRunning();
        }
    }
}

extension LoginRegisterVC: BirthdayAlertViewDelegate {
    func submitButtonPressed(datePickerValue: String) {
        birthdayField.text = datePickerValue
    }
}

