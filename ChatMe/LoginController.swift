//
//  LoginController.swift
//  ChatMe
//
//  Created by Sultan on 30/03/18.
//  Copyright © 2018 Sultan. All rights reserved.
//

import UIKit
import FirebaseAuth

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
        
        registerBtn.layer.cornerRadius = 10
        registerBtn.clipsToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = Auth.auth().currentUser{
            self.performSegue(withIdentifier: "mainActivity", sender: self)
        }
    }
    
    @IBAction func registerActivity(_ sender: Any) {
        performSegue(withIdentifier: "registerSegue", sender: sender)
    }
    
    @IBAction func loginActivity(_ sender: Any) {
        if (emailTextField.text != "" && passwordTextField.text != ""){
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if user != nil { //User Signed In Successfully
                    self.performSegue(withIdentifier: "mainActivity", sender: sender)
                } else { //Failed Authentication
                    print(error?.localizedDescription as Any)
                    
                }
            })
        }
    }
    
}

