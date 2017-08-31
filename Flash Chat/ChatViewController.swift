//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    //outlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    //vars
    var messages = [Message]()
    
    //system functions
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        messageTableView.estimatedRowHeight = 120.0
        messageTableView.rowHeight = UITableViewAutomaticDimension
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableviewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        retrieveMessages()
    }
    
    //actions
    @IBAction func sendPressed(_ sender: AnyObject) {
        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        guard let message = messageTextfield.text, message.characters.count > 0  else {
            return
        }
        
        let messageDB = Database.database().reference().child("Messages")
        let messageDict = ["Sender": Auth.auth().currentUser?.email, "MessageBody": message]
        
        messageDB.childByAutoId().setValue(messageDict){
            (error, ref) in
            if error == nil {
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                
                self.messageTextfield.text = ""
            }
        }
    }
    @IBAction func logOutPressed(_ sender: AnyObject) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        }catch{}
    }
    
    //custom actions
    func tableviewTapped(){
        messageTextfield.endEditing(true)
    }
    func retrieveMessages(){
        let messageDB = Database.database().reference().child("Messages")
        messageDB.observe(.childAdded, with: {
            (snapshot) in
            let snap = snapshot.value as! Dictionary<String, String>
            let message = Message()
            message.message = snap["MessageBody"]!
            message.sender = snap["Sender"]!
            self.messages.append(message)
            self.messageTableView.reloadData()
        })
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.messageBody.text = messages[indexPath.row].message
        cell.senderUsername.text = messages[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        return cell
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
}
