//
//  RegisterController.swift
//  ChatMe
//
//  Created by Sultan on 01/04/18.
//  Copyright © 2018 Sultan. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterController: UIViewController {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
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
    
    @IBAction func registerUser(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil { //Sign Up Successful
                print("Success")
                DispatchQueue.main.async {
                    let userNameChangeReq = Auth.auth().currentUser?.createProfileChangeRequest()
                    userNameChangeReq?.displayName = self.usernameTextField.text!
                    userNameChangeReq?.commitChanges(completion: { (error) in
                        if error==nil{
                            print("UserName Changed")
                        } else {
                            print(error?.localizedDescription as Any)
                        }
                    })
                }
               self.dismiss(animated: true, completion: nil) //Return To LoginController
            } else { //Sign Up Unsuccessful
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    
}
