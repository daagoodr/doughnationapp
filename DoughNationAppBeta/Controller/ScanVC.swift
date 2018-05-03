//
//  ViewController.swift
//  DoughNationApp
//
//  Created by Damon Goodrich-Houska on 8/16/17.
//  Copyright © 2017 Damon Goodrich-Houska. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class ScanVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    //ui image view insertion(possibly for square pic later)
    
    //ties image view for QR scan to viewcontroller
    @IBOutlet weak var square: UIView!
    
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
    
    override func viewDidLoad()
    {
        
        if let data = UserDefaults.standard.data(forKey: "currentUser"), let currentUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? CurrentUser {
            Alamofire.request("https://doughnationgifts.com/api/user/type/id/query/\(currentUser.id)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": DN_HEADER]).responseString(completionHandler: { (response) in
                do {
                    if let data = response.data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let info = json["data"] as? [String: Any] {
                        print("JSON1: \(info)")
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
            })
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession.isRunning == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession.isRunning == true) {
            captureSession.stopRunning();
        }
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // This is the delegate'smethod that is called when a code is readed
       
        print(metadataObjects)
        for metadata in metadataObjects {
            let readableObject = metadata as! AVMetadataMachineReadableCodeObject
            if let components = readableObject.stringValue?.components(separatedBy: ",") {
                if components[1] != nil {
                    Alamofire.request("https://doughnationgifts.com/api/user/type/id/query/\(components[1])", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": DN_HEADER]).responseString(completionHandler: { (response) in
                        
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
                
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Invalid code, please try again", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
    }
    
    private func setupCamera() {
        
        guard let device = device else { return }
        let input = try? AVCaptureDeviceInput(device: device)
        
        if self.captureSession.canAddInput(input!) {
            self.captureSession.addInput(input!)
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        if let videoPreviewLayer = self.previewLayer {
            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer.frame = square.bounds
            //view.layer.addSublayer(videoPreviewLayer)
            square.layer.addSublayer(videoPreviewLayer)
            
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
    /*
    @IBAction func backSelected() {
        self.dismiss(animated: true, completion: nil)
    }
    */
    @IBAction func useCodeSelected() {
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
    
    @IBAction func logoutPressed() {
        wePayUserLogout()
    }
    
    @IBAction func unwindToScanVC(segue: UIStoryboardSegue) {}
    
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

extension ScanVC: CustomAlertViewDelegate {
    
    func submitButtonTapped(codeEntryValue: Int) {
        print("Entry Code Value is \(codeEntryValue)")
        
        Alamofire.request("https://doughnationgifts.com/api/user/type/id/query/\(codeEntryValue)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": DN_HEADER]).responseString(completionHandler: { (response) in
            
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

