//
//  ProfileViewController.swift
//  Gelengram
//
//  Created by Admin on 21.12.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var currentUser = UserModel() {
        didSet {
            if currentUser.id != userToShow.id {
                logoutButton.isHidden = true
            }
        }
    }
    var userToShow = UserModel()
    
    var userManager = UserManager()

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userManager.delegate = self
        
        userManager.getCurrentUser()
        
        usernameLabel.text = userToShow.name
        emailLabel.text = userToShow.email
      
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        userManager.logOut()
    }
}

extension ProfileViewController: UserManagerDelegate {
    
    func fetchUser(_ user: UserModel, _ isCurrent: Bool) {
        if isCurrent {
            currentUser = user
        }
    }
    
    func logOutResult() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
