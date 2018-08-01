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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sender = segue.destination as? CaptureViewController, let name = nameTF.text, !name.isEmpty {
            sender.username = name
        }
    }
}

