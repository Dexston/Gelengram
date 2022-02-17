//
//  PostViewController.swift
//  Gelengram
//
//  Created by Admin on 21.12.2021.
//

import UIKit

class PostViewController: UIViewController {
    
    @IBOutlet var usernameButton: UIBarButtonItem!
    @IBOutlet var userAvatarButton: UIBarButtonItem!
    
    @IBOutlet var authorName: UIButton!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var likesHeartImage: UIButton!
    @IBOutlet var likesCount: UIButton!
    
    var currentUser = UserModel()
    var author = UserModel()
    var profileToShow = UserModel()
    
    var post = PostModel()
    var postManager = PostManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postManager.delegatePostVC = self
        
        usernameButton.title = currentUser.name
        authorName.setTitle(author.name, for: .normal)

        postImageView.image = UIImage(systemName: post.image)
        
        postManager.loadLikes(for: post)
 
    }
        
    @IBAction func profilePressed(_ sender: UIBarButtonItem) {
        profileToShow = currentUser
        performSegue(withIdentifier: K.Segues.postToProfile, sender: self)
    }
    @IBAction func authorNamePressed(_ sender: UIButton) {
        profileToShow = author
        performSegue(withIdentifier: K.Segues.postToProfile, sender: self)
    }
    
    @IBAction func likesPressed(_ sender: UIButton) {
        postManager.like(post)
        postManager.loadLikes(for: post)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.postToProfile {
            let destinationVC = segue.destination as! ProfileViewController
            destinationVC.userToShow = profileToShow
        }
    }
}

extension PostViewController: UserManagerDelegate {
    
    func fetchUser(_ user: UserModel, _ isCurrent: Bool) {
        if isCurrent {
            currentUser = user
        } else {
            author = user
        }
    }
}

extension PostViewController: PostManagerDelegate {
    
    func didPostUpdate() {
        likesCount.setTitle("\(post.likes.count)", for: .normal)
        let heartIcon = postManager.isLiked(post) ? "heart.fill" : "heart"
        likesHeartImage.setImage(UIImage(systemName: heartIcon), for: .normal)
    }
    
}
