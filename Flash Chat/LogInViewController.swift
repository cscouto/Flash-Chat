//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        guard let email = emailTextfield.text, email.characters.count > 0  else {
            return
        }
        guard let password = passwordTextfield.text, password.characters.count > 0  else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password){
            (user, error) in
            SVProgressHUD.dismiss()
            if error == nil {
                self.performSegue(withIdentifier: "goToChat", sender: nil)
            }
        }
    }
    


    
}  
