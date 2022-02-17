//
//  PostData.swift
//  Gelengram
//
//  Created by Admin on 27.12.2021.
//

import Foundation

struct PostData: Decodable {
    let authorID: String
    let date: String
    let image: String
    let likes: [String]
}
