//
//  PostCardCell.swift
//  Gelengram
//
//  Created by Admin on 21.12.2021.
//

import UIKit

class PostCardCell: UITableViewCell {

    @IBOutlet var authorName: UIButton!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var likesHeartImage: UIButton!
    @IBOutlet var likesCount: UIButton!
    
    var post = PostModel()
    var author = UserModel() {
        didSet {
            authorName.setTitle(author.name, for: .normal)
        }
    }
    var postManager = PostManager()
    var userManager = UserManager()
    
    var feedVC: FeedViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userManager.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fill(_ incomingPost: PostModel, for feedVC: FeedViewController) {
        self.feedVC = feedVC
        self.post = incomingPost
        userManager.getUserInfo(by: post.authorID)
        postImageView.image = UIImage(systemName: post.image)
        likesCount.setTitle("\(post.likes.count)", for: .normal)
        let heartIcon = postManager.isLiked(post) ? "heart.fill" : "heart"
        likesHeartImage.setImage(UIImage(systemName: heartIcon), for: .normal)
    }
    
    @IBAction func viewFullPostPressed(_ sender: UIButton) {
        if let feedVC = feedVC {
            feedVC.showFullPost(post, author)
        }
    }
    @IBAction func authorNamePressed(_ sender: UIButton) {
        if let feedVC = feedVC {
            feedVC.postAuthorProfile(author)
        }
    }
    @IBAction func likesPressed(_ sender: UIButton) {
        postManager.like(post)
    }
}


extension PostCardCell: UserManagerDelegate {
    
    func fetchUser(_ user: UserModel, _ isCurrent: Bool) {
        if !isCurrent {
            author = user
        }
    }
}
