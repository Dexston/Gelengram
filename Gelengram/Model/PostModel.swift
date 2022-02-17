//
//  PostModel.swift
//  Gelengram
//
//  Created by Admin on 21.12.2021.
//

import Foundation

struct PostModel {
    var id: String
    var authorID: String
    var date: String
    var image: String
    var likes: [String]
    
    init() {
        id = "0"
        authorID = "empty"
        date = "0"
        image = "xmark"
        likes = []
    }
    
    init(id: String, authorID: String, date: String, image: String, likes: [String]) {
        self.id = id
        self.authorID = authorID
        self.date = date
        self.image = image
        self.likes = likes
    }
    
}


