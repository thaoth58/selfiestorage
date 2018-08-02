//
//  ViewController.swift
//  camera-face
//
//  Created by Thao Truong on 8/1/18.
//  Copyright © 2018 GEM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nextAction(_ sender: Any) {
        if let captureVC = self.storyboard?.instantiateViewController(withIdentifier: "CaptureViewController") as? CaptureViewController {
            if let name = nameTF.text?.replacingOccurrences(of: " ", with: ""), !name.isEmpty {
                captureVC.username = name
                self.navigationController?.pushViewController(captureVC, animated: true)
            } else {
                let alert = UIAlertController.init(title: "Error", message: "Please enter your name", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
}

