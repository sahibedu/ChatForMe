//
//  RegisterController.swift
//  ChatMe
//
//  Created by Sultan on 01/04/18.
//  Copyright © 2018 Sultan. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.layer.cornerRadius = 10
        backBtn.clipsToBounds = true
        
        registerBtn.layer.cornerRadius = 20
        registerBtn.clipsToBounds = true
    }

    @IBAction func backActivity(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
