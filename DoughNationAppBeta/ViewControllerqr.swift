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
    @IBOutlet weak var square: UIImageView!
    
    var video = AVCaptureVideoPreviewLayer()
    
    
    
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //creating session
        let session = AVCaptureSession()
        
        //Define capture Device
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            let input = try AVCaptureDeviceInput (device: captureDevice!)
            session.addInput(input)
        }
            
        catch{
            print ("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        
        self.view.bringSubview(toFront: square)
        
        session.startRunning()
        
    }
    //takes info from video capture session
    func metadataOutput(captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != nil
        {
            //checks if video can read object
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                //checks if object is valid QR Code
                if object.type == AVMetadataObject.ObjectType.qr
                {
                    //checks if QR code is tied to valid URL
                    let url = URL(string: object.stringValue!)!
                    if #available(iOS 10.0, *)
                    {
                        //Auto open valid URL in default browser "Safari"
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                    
                }
            }
            
            
        }
    }
    
    override  func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

