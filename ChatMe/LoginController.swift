//
//  LoginController.swift
//  ChatMe
//
//  Created by Sultan on 30/03/18.
//  Copyright © 2018 Sultan. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.layer.cornerRadius = 20
        emailTextField.clipsToBounds = true
        
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.cornerRadius = 20
        passwordTextField.clipsToBounds = true
        
        loginBtn.layer.cornerRadius = 20
        loginBtn.clipsToBounds = true
        
        registerBtn.layer.cornerRadius = 20
        registerBtn.clipsToBounds = true
        
    }
    
    @IBAction func registerActivity(_ sender: Any) {
        performSegue(withIdentifier: "registerSegue", sender: sender)
    }
    
    


}

