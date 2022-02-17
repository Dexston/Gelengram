//
//  ViewController.swift
//  Gelengram
//
//  Created by Admin on 25.11.2021.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    var userManager = UserManager()
    
    override func viewWillAppear(_ animated: Bool) {
        emailField.text = ""
        passwordField.text = ""
        errorLabel.text = ""
        errorLabel.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userManager.delegate = self
        
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailField.text, let password = passwordField.text {
            userManager.logIn(email, password)
        }
    }

    @IBAction func registrationPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: K.Segues.loginToReg, sender: self)
    }
    
}
extension WelcomeViewController: UserManagerDelegate {
    
    func logInResult(isSuccessfull: Bool, errorText: String) {
        errorLabel.text = errorText
        errorLabel.isHidden = isSuccessfull
        if isSuccessfull {
            performSegue(withIdentifier: K.Segues.loginToFeed, sender: self)
        }
    }
}

