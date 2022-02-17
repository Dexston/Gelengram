//
//  PostManager.swift
//  Gelengram
//
//  Created by Admin on 29.12.2021.
//

import Foundation
import Firebase

protocol PostManagerDelegate {
    func didPostUpdate()
}

struct PostManager {
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser!
   
    var delegateFeedVC: FeedViewController?
    var delegatePostVC: PostViewController?
    
    func loadPosts() {
        if let delegate = delegateFeedVC {
            db.collection(K.FStore.postsCollection).order(by: K.FStore.postDate).addSnapshotListener { querySnapshot, error in
                delegate.postsByDate = [String]()
                if let e = error {
                    print("Error: \(e)")
                } else {
                    if let documents = querySnapshot?.documents {
                        for doc in documents {
                            let postID = doc.documentID
                            delegate.postsByDate.append(postID)
                            let data = doc.data()
                            if !delegate.loadedPosts.keys.contains(postID) {
                                if let authorID = data[K.FStore.postAuthorID] as? String,
                                   let date = data[K.FStore.postDate] as? String,
                                   let image = data[K.FStore.postImage] as? String,
                                   let likes = data[K.FStore.postLikes] as? [String] {
                                    delegate.loadedPosts[postID] = PostModel(id: postID,
                                                                             authorID: authorID,
                                                                             date: date,
                                                                             image: image,
                                                                             likes: likes)
                                    delegate.didPostUpdate()
                                }
                            } else {
                                if let likes = data[K.FStore.postLikes] as? [String] {
                                    delegate.loadedPosts[postID]?.likes = likes
                                    delegate.didPostUpdate()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadLikes(for post: PostModel) {
        db.collection(K.FStore.postsCollection).document(post.id).getDocument { docSnapshot, error in
            if let doc = docSnapshot,
               let data = doc.data(),
               let likes = data[K.FStore.postLikes] as? [String] {
                self.delegatePostVC?.post.likes = likes
                self.delegatePostVC?.didPostUpdate()
            }
        }
    }
    
    func like(_ post: PostModel) {
        let cloudPost = db.collection(K.FStore.postsCollection).document(post.id)
        if isLiked(post) {
            cloudPost.updateData([K.FStore.postLikes : FieldValue.arrayRemove([user.uid])])
        } else {
            cloudPost.updateData([K.FStore.postLikes : FieldValue.arrayUnion([user.uid])])
        }
    }
    
    func isLiked(_ post: PostModel) -> Bool {
        return post.likes.contains(user.uid)
    }
    
}
