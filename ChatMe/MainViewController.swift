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
    @IBOutlet weak var usernameTextLabel: UILabel!
    
    var dbReference : DatabaseReference!
    var dbHandler : DatabaseHandle!
    var storageReference : StorageReference!
    var messages : [DataSnapshot]! = []
    var currentUser = "Optimus Prime"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseSetUp()
        messageTableView.delegate = self
        messageTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func databaseSetUp(){
        dbReference = Database.database().reference()
        dbHandler = dbReference.child("messages").observe(.childAdded){(snapshot : DataSnapshot) in
            self.messages.append(snapshot)
            self.messageTableView.insertRows(at: [IndexPath(row: self.messages.count-1,section: 0)], with: .automatic)
            self.messageTableView.reloadData()
        }
        currentUser = (Auth.auth().currentUser?.displayName)!
        usernameTextLabel.text = "\(currentUser) Logged In"
    }
    
    func stotageSetUp(){
        storageReference = Storage.storage().reference()
    }
    
    func sendPhotoMsg(imageData:Data){
        
    }
    
    //--------------------------------------------------------------------------------------------------------
    //MARK: ACTIONS
    //--------------------------------------------------------------------------------------------------------
    
    @IBAction func CameraAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func SendMsgAction(_ sender: Any) {
        let data = [Constants.messageFields.username : "\(currentUser)",Constants.messageFields.text : messageTextField.text!]
        messageTextField.text = ""
        messageTextField.resignFirstResponder()
        dbReference.child("messages").childByAutoId().setValue(data)
    }
    @IBAction func logOutAction(_ sender: UIButton) {
        try? Auth.auth().signOut()
        performSegue(withIdentifier: "backToLogin", sender: sender)
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

extension MainViewController : UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageToSave = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData = UIImageJPEGRepresentation(imageToSave, 0.8)
        sendPhotoMsg(imageData: imageData!)
        picker.dismiss(animated: true, completion: nil)
    }
}
