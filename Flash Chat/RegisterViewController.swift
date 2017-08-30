//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        guard let email = emailTextfield.text, email.characters.count > 0  else {
            return
        }
        guard let password = passwordTextfield.text, password.characters.count > 0  else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password){
            (user, error) in
            if error == nil {
                self.performSegue(withIdentifier: "goToChat", sender: nil)
            }
        }
    } 
}
