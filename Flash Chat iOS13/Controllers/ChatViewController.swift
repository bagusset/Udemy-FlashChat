//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var message: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem()
        register()
        loadMessages()
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 44;
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email{
            db.collection(Constants.FStore.collectionName).addDocument(data: [
                Constants.FStore.senderField: messageSender,
                Constants.FStore.bodyField: messageBody,
                Constants.FStore.dateField: Date().timeIntervalSince1970
            ]) {(error) in
                if let e = error {
                    print("There as issue saving data,\(e)")
                } else {
                    print("succsecfully saved !")
                }
            }
            
        }
        
    }
    
    @IBAction func logOutBtn(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    func navigationItem(){
        
        navigationItem.hidesBackButton = true
        title = "⚡️FlashChat"
        
    }
    
    func register(){
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
    }
    
    func loadMessages(){
        
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField)
            .addSnapshotListener{(QuerySnapshot, error) in
            
            self.message = []
            
            if let e = error {
                print("There as issue saving data,\(e)")
            } else {
                if let snapshotDocument = QuerySnapshot?.documents {
                    for doc in snapshotDocument {
                        let data = doc.data()
                        if let messageSender = data[Constants.FStore.senderField] as? String, let messageBody = data[Constants.FStore.bodyField] as? String {
                            let newMessages = Message(sender: messageSender, body: messageBody)
                            self.message.append(newMessages)
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let messages = message[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        cell.messageLabel.text = messages.body
        
        if messages.sender == Auth.auth().currentUser?.email{
            
            cell.avatarLeftImage.isHidden = true
            cell.avatarImage.isHidden = false
            cell.bubbleMessageView.backgroundColor = UIColor(named:  Constants.BrandColors.purple)
            cell.messageLabel.textColor = UIColor(named: Constants.BrandColors.lightPurple)
            cell.messageLabel.textAlignment = NSTextAlignment.right
            
        }
        
        else {
            
            cell.avatarLeftImage.isHidden = false
            cell.avatarImage.isHidden = true
            cell.bubbleMessageView.backgroundColor = UIColor(named:  Constants.BrandColors.lightPurple)
            cell.messageLabel.textColor = UIColor(named: Constants.BrandColors.purple)
            cell.messageLabel.textAlignment = NSTextAlignment.left
            
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    
    
}

extension ChatViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
