//
//  ViewController.swift
//  DoughNationApp
//
//  Created by Damon Goodrich-Houska on 8/16/17.
//  Copyright © 2017 Damon Goodrich-Houska. All rights reserved.
//

import UIKit
import AVFoundation

class ViewControllerqr: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    //ui image view insertion(possibly for square pic later)
    
    //ties image view for QR scan to viewcontroller
    @IBOutlet weak var square: UIView!
    
    var videoCaptureDevice: AVCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)!
    var device = AVCaptureDevice.default(for: AVMediaType.video)
    var output = AVCaptureMetadataOutput()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var captureSession = AVCaptureSession()
    var code: String?
    
    var scannedCode = UILabel()
    
    override func viewDidLoad()
    {
        
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
            if let code = readableObject.stringValue {
                var urlCode = URL(string: code)
                if urlCode?.absoluteString.range(of: "http") == nil {
                    urlCode = URL(string: "http://\(code)")
                }
                if urlCode != nil && UIApplication.shared.canOpenURL(urlCode!) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(urlCode!, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(urlCode!)
                        }
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Invalid code, please try again", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
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
    
}

