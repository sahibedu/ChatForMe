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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialView()
        subscribeToKeyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = Auth.auth().currentUser{
            self.performSegue(withIdentifier: "mainActivity", sender: self)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    fileprivate func initialView() {
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.layer.cornerRadius = 20
        emailTextField.clipsToBounds = true
        emailTextField.delegate = self
        
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.cornerRadius = 20
        passwordTextField.clipsToBounds = true
        passwordTextField.delegate = self
        
        loginBtn.layer.cornerRadius = 20
        loginBtn.clipsToBounds = true
        
        registerBtn.layer.cornerRadius = 10
        registerBtn.clipsToBounds = true
    }
    
    func showAlertView(alertMessage : String){
        let alertController = UIAlertController()
        alertController.title = "Error"
        alertController.message = alertMessage
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func registerActivity(_ sender: Any) {
        performSegue(withIdentifier: "registerSegue", sender: sender)
    }
    
    @IBAction func loginActivity(_ sender: Any) {
        if (emailTextField.text != "" && passwordTextField.text != ""){
            activityIndicator.startAnimating()
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if user != nil { //User Signed In Successfully
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "mainActivity", sender: sender)
                } else { //Failed Authentication
                    self.showAlertView(alertMessage: (error?.localizedDescription)!)
                    self.activityIndicator.stopAnimating()
                }
            })
        }
    }
    
}

extension LoginController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LoginController{
    func subscribeToKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(returnKeyboardBack), name: .UIKeyboardWillHide, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        if (passwordTextField.isFirstResponder) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    @objc func returnKeyboardBack(){
        if (passwordTextField.isFirstResponder) {
            view.frame.origin.y=0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
}




