//
//  UserManager.swift
//  Gelengram
//
//  Created by Admin on 29.12.2021.
//

import Foundation
import Firebase

protocol UserManagerDelegate {
    func fetchUser(_ user: UserModel, _ isCurrent: Bool)
    func registerResult(isSuccessfull: Bool, errorText: String)
    func logInResult(isSuccessfull: Bool, errorText: String)
    func logOutResult()
}

extension UserManagerDelegate {
    func fetchUser(_ user: UserModel, _ isCurrent: Bool) {}
    func registerResult(isSuccessfull: Bool, errorText: String) {}
    func logInResult(isSuccessfull: Bool, errorText: String) {}
    func logOutResult() {}
}

class UserManager {
    let db = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    
    var delegate: UserManagerDelegate?
    var isCurrent = false
        
    func getCurrentUser() {
        isCurrent = true
        if let currentUser = currentUser {
            getUserInfo(by: currentUser.uid)
        }
    }
    
    func getUserInfo(by id: String) {
        db.collection(K.FStore.usersCollection).document(id).getDocument { docSnapshot, error in
            if let doc = docSnapshot,
               let data = doc.data(),
               let name = data[K.FStore.userNameField] as? String,
               let email = data[K.FStore.userEmailField] as? String {
                let user = UserModel(id: id, name: name, email: email)
                self.delegate?.fetchUser(user, self.isCurrent)
                self.isCurrent = false
            }
        }
    }
    
    func register(_ email: String, _ password: String, _ realName: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.delegate?.registerResult(isSuccessfull: false, errorText: error.localizedDescription)
            } else if let user = authResult?.user {
                self.db.collection(K.FStore.usersCollection).document(user.uid)
                    .setData([K.FStore.userNameField : realName,
                              K.FStore.userEmailField : email])
                self.delegate?.registerResult(isSuccessfull: true, errorText: "")
            }
        }
    }
    
    func logIn(_ email: String, _ password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.delegate?.logInResult(isSuccessfull: false, errorText: error.localizedDescription)
            } else {
                self.delegate?.logInResult(isSuccessfull: true, errorText: "")
            }
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            delegate?.logOutResult()
        } catch {
            print("Error signing out: %@", error)
        }
    }
}
