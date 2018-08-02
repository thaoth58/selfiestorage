//
//  CaptureViewController.swift
//  camera-face
//
//  Created by Thao Truong on 8/1/18.
//  Copyright © 2018 GEM. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD

class CaptureViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var username = "No-name"
    
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var error: NSError?
    
    var uploaded = 0
    var total = 0
    
    let APPLICATION_ID = "92EDABB5-A180-564B-FF11-8B3A88B98400"
    let API_KEY = "ECAD7F52-2DD8-B327-FF47-7C8C0B35F200"
    let SERVER_URL = "https://api.backendless.com"
    var currentImageData: Data? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        
        Backendless.sharedInstance().hostURL = SERVER_URL
        Backendless.sharedInstance().initApp(APPLICATION_ID, apiKey: API_KEY)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configView() {
        let devices = AVCaptureDevice.devices().filter{ $0.hasMediaType(AVMediaType.video) && $0.position == AVCaptureDevice.Position.front }
        if let captureDevice = devices.first {
            var deviceInput: AVCaptureDeviceInput? = nil
            do {
                deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            } catch {
                return
            }
            guard let captureDeviceInput = deviceInput else { return }
            
            captureSession.addInput(captureDeviceInput)
            captureSession.sessionPreset = AVCaptureSession.Preset.photo
            captureSession.startRunning()
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
        }
    }
    
    func updateCurrentLabel() {
        currentLabel.text = "Uploaded: \(uploaded.description)/\(total.description)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.bounds = view.bounds
        previewLayer.position = CGPoint.init(x: view.bounds.midX, y: view.bounds.midY)
        previewLayer.videoGravity = .resizeAspectFill
        let cameraPreview = UIView(frame: containerView.bounds)
        cameraPreview.layer.addSublayer(previewLayer)
        containerView.addSubview(cameraPreview)
    }

    @IBAction func captureAction(_ sender: Any) {
        if let videoConnection = stillImageOutput.connection(with: AVMediaType.video) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                if let imageDataSampleBuffer = imageDataSampleBuffer {
                    if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer) {
                        self.imageContainerView.isHidden = false
                        self.imageView.image = UIImage.init(data: imageData)
                        self.currentImageData = imageData
                    }
                }
            }
        }
    }
    
    @IBAction func uploadAction(_ sender: Any) {
        total += 1
        updateCurrentLabel()
        let name = username + "-" + Date.timeIntervalSinceReferenceDate.description + ".jpeg"
        if let data = currentImageData {
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
            Backendless.sharedInstance().fileService.uploadFile(name, content: data, response: { (file) in
                self.uploaded += 1
                self.updateCurrentLabel()
                SVProgressHUD.dismiss()
                self.imageContainerView.isHidden = true
                self.currentImageData = nil
            }) { (error) in
                SVProgressHUD.dismiss()
                if let error = error {
                    print("Upload error: " + error.description)
                }
                self.imageContainerView.isHidden = true
                self.currentImageData = nil
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.imageContainerView.isHidden = true
        currentImageData = nil
    }
    
    func uploadImage(data: Data) {
    }
}
