//
//  MainViewController.swift
//  ChatMe
//
//  Created by Sultan on 01/04/18.
//  Copyright © 2018 Sultan. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    @IBOutlet weak var messageTextField: UITextField!
    
    var dbReference : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseSetUp()
    }
    
    func databaseSetUp(){
        dbReference = Database.database().reference()
        print("Database Referenced")
    }
    
    @IBAction func CameraAction(_ sender: Any) {
    }
    
    @IBAction func SendMsgAction(_ sender: Any) {
        print(messageTextField.text!)
        let messageText = messageTextField.text!
        messageTextField.text = ""
        messageTextField.resignFirstResponder()
        dbReference.child("messages").childByAutoId().setValue(messageText)
    }
}
