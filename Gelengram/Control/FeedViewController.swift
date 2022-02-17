//
//  LentaViewController.swift
//  Gelengram
//
//  Created by Admin on 25.11.2021.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var usernameButton: UIBarButtonItem!
    @IBOutlet var userAvatarButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    var currentUser = UserModel() {
        didSet {
            usernameButton.title = currentUser.name
        }
    }
    var userManager = UserManager()
    var postManager = PostManager()
    
    var profileToShow = UserModel()
    var postToShow = PostModel()
    
    var postsByDate = [String]()
    var loadedPosts = [String: PostModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        userManager.delegate = self
        postManager.delegateFeedVC = self
        
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        userManager.getCurrentUser()
        
        postManager.loadPosts()
        
        tableView.register(UINib(nibName: K.PostCardCell.nibName, bundle: nil), forCellReuseIdentifier: K.PostCardCell.identifier)

    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let postID = postsByDate[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: K.PostCardCell.identifier, for: indexPath) as! PostCardCell
        if let post = loadedPosts[postID] {
            cell.fill(post, for: self)
        }
   
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsByDate.count
    }
       
    @IBAction func profilePressed(_ sender: UIBarButtonItem) {
        profileToShow = currentUser
        performSegue(withIdentifier: K.Segues.feedToProfile, sender: self)
    }
    
    func postAuthorProfile(_ author: UserModel) {
        profileToShow = author
        performSegue(withIdentifier: K.Segues.feedToProfile, sender: self)
    }
    
    func showFullPost(_ post: PostModel, _ author: UserModel) {
        postToShow = post
        profileToShow = author
        performSegue(withIdentifier: K.Segues.feedToPostView, sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.feedToProfile {
            let destinationVC = segue.destination as! ProfileViewController
            destinationVC.userToShow = profileToShow
        }
        if segue.identifier == K.Segues.feedToPostView {
            let destinationVC = segue.destination as! PostViewController
            destinationVC.post = postToShow
            destinationVC.author = profileToShow
            destinationVC.currentUser = currentUser
        }
    }
}


extension FeedViewController: PostManagerDelegate {
    func didPostUpdate() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension FeedViewController: UserManagerDelegate {
    func fetchUser(_ user: UserModel, _ isCurrent: Bool) {
        if isCurrent {
            currentUser = user
        }
    }
}
