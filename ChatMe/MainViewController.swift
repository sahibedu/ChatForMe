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
    @IBOutlet weak var messageTableView: UITableView!
    
    var dbReference : DatabaseReference!
    var dbHandler : DatabaseHandle!
    var messages : [DataSnapshot]! = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseSetUp()
        messageTableView.delegate = self
        messageTableView.dataSource = self
    }
    
    func databaseSetUp(){
        dbReference = Database.database().reference()
        dbHandler = dbReference.child("messages").observe(.childAdded){(snapshot : DataSnapshot) in
            self.messages.append(snapshot)
            self.messageTableView.insertRows(at: [IndexPath(row: self.messages.count-1,section: 0)], with: .automatic)
            self.messageTableView.reloadData()
        }
    }
    
    deinit {
        dbReference.child("messages").removeObserver(withHandle: dbHandler)
    }
    //--------------------------------------------------------------------------------------------------------
    //MARK: ACTIONS
    //--------------------------------------------------------------------------------------------------------
    
    @IBAction func CameraAction(_ sender: Any) {
        print("Camera Button Called")
    }
    
    @IBAction func SendMsgAction(_ sender: Any) {
        let data = [Constants.messageFields.username : "Optimus Prime",Constants.messageFields.text : messageTextField.text!]
        messageTextField.text = ""
        messageTextField.resignFirstResponder()
        dbReference.child("messages").childByAutoId().setValue(data)
    }
}


extension MainViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prototypeCell = messageTableView.dequeueReusableCell(withIdentifier: "messageBox", for: indexPath)
        let messageSnapshot : DataSnapshot = messages[indexPath.row]
        let message = messageSnapshot.value as! [String:String]
        prototypeCell.textLabel?.text = message[Constants.messageFields.username]! + ": " + message[Constants.messageFields.text]!
        return prototypeCell
    }
    
    
}
