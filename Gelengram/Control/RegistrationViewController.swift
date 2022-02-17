//
//  RegistrationViewController.swift
//  Gelengram
//
//  Created by Admin on 21.12.2021.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet var realNameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    var userManager = UserManager()
    
    override func viewWillAppear(_ animated: Bool) {
        realNameField.text = ""
        emailField.text = ""
        passwordField.text = ""
        errorLabel.text = ""
        errorLabel.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userManager.delegate = self

    }
    
    @IBAction func registrationPressed(_ sender: UIButton) {
        errorLabel.isHidden = true
        if let email = emailField.text, let password = passwordField.text, let realName = realNameField.text {
            userManager.register(email, password, realName)
            view.endEditing(true)
        }
    }
}

extension RegistrationViewController: UserManagerDelegate {
    
    func registerResult(isSuccessfull: Bool, errorText: String) {
        
        errorLabel.text = errorText
        errorLabel.isHidden = isSuccessfull
        if isSuccessfull {
            performSegue(withIdentifier: K.Segues.regToFeed, sender: self)
        }
    }
}
