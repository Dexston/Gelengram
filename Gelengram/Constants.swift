//
//  Constants.swift
//  Gelengram
//
//  Created by Admin on 29.12.2021.
//

import Foundation

enum K {
    enum Segues {
        static let loginToFeed = "LoginToFeed"
        static let loginToReg = "LoginToRegistration"
        
        static let regToFeed = "RegistrationToFeed"
        
        static let feedToProfile = "FeedToProfile"
        static let feedToPostView = "FeedToPostView"
        
        static let postToProfile = "PostToProfile"
    }
    
    enum PostCardCell {
        static let identifier = "reusablePostCell"
        static let nibName = "PostCardCell"
        
    }
    
    enum FStore {
        static let postsCollection = "posts"
        static let postAuthorID = "authorID"
        static let postDate = "date"
        static let postImage = "image"
        static let postLikes = "likes"
        
        static let usersCollection = "users"
        static let userNameField = "name"
        static let userEmailField = "email"
    }
}
