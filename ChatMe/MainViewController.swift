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
        databaseSetup()
        delegateSetup()
        storageSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    fileprivate func delegateSetup() {
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextField.delegate = self
    }
    
    func databaseSetup(){
        dbReference = Database.database().reference()
        dbHandler = dbReference.child("messages").observe(.childAdded){(snapshot : DataSnapshot) in
            self.messages.append(snapshot)
            self.messageTableView.insertRows(at: [IndexPath(row: self.messages.count-1,section: 0)], with: .automatic)
            self.messageTableView.reloadData()
        }
        currentUser = (Auth.auth().currentUser?.displayName)!
        usernameTextLabel.text = "\(currentUser) Logged In"
    }
    
    func storageSetup(){
        storageReference = Storage.storage().reference()
    }
    //--------------------------------------------------------------------------------------------------------
    //MARK: ACTIONS
    //--------------------------------------------------------------------------------------------------------
    
    @IBAction func CameraAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    fileprivate func sendMessage(imageurl:String = "") {
        if imageurl == ""{
            if messageTextField.text != ""{
                let data = [Constants.messageFields.username : "\(currentUser)",Constants.messageFields.text : messageTextField.text!]
                messageTextField.text = ""
                messageTextField.resignFirstResponder()
                dbReference.child("messages").childByAutoId().setValue(data)
            }
        } else {
            let data = [Constants.messageFields.username : "\(currentUser)",Constants.messageFields.imageURL : imageurl]
            dbReference.child("messages").childByAutoId().setValue(data)
            
        }
    }
    
    @IBAction func SendMsgAction(_ sender: Any) {
        sendMessage()
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
        if message[Constants.messageFields.text] == nil{
            let imageURL = message[Constants.messageFields.imageURL]
            Storage.storage().reference(forURL: imageURL!).getData(maxSize: INT64_MAX, completion: { (data, error) in
                if error == nil {
                    let messageImage = UIImage.init(data: data!, scale: 50)
                    if prototypeCell == tableView.cellForRow(at: indexPath){
                        prototypeCell.imageView?.image = messageImage
                        prototypeCell.setNeedsLayout()
                    }
                }
            })
            prototypeCell.textLabel?.text = "By \(message[Constants.messageFields.username] ?? "")"
        } else {
            prototypeCell.textLabel?.text = message[Constants.messageFields.username]! + ": " + message[Constants.messageFields.text]!
        }
        return prototypeCell
    }
}

//MARK:IMAGEPICKER DELEGATE

extension MainViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageToSave = info[UIImagePickerControllerOriginalImage] as? UIImage , let imageData = UIImageJPEGRepresentation(imageToSave, 0.8){
            sendPhotoMsg(imageData: imageData)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func sendPhotoMsg(imageData : Data){
        let imagePath = "chat-photos/"+(Auth.auth().currentUser?.uid)!+"\(Double(Date.timeIntervalSinceReferenceDate*1000)).jpeg"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        storageReference.child(imagePath).putData(imageData, metadata: metaData) { (metadata, error) in
            if error == nil{
                print("Image Saved Successfully")
                self.sendMessage(imageurl: self.storageReference.child(metaData.path!).description)
            } else{
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK:TEXTFIELD DELEGATE
extension MainViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
//MARK:KEYBOARD UI CHANGE

extension MainViewController{
    func subscribeToKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(returnKeyboardBack), name: .UIKeyboardWillHide, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        if (messageTextField.isFirstResponder) {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    @objc func returnKeyboardBack(){
        if (messageTextField.isFirstResponder) {
            view.frame.origin.y=0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
}

