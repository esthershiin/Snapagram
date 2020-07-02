//
//  FeedData.swift
//  Snapagram
//
//  Created by Arman Vaziri on 3/8/20.
//  Copyright © 2020 iOSDeCal. All rights reserved.
//

import Foundation
import UIKit
import Firebase

// Create global instance of the feed
var feed = FeedData()
let db = Firestore.firestore()
let storage = Storage.storage()

class Thread {
    var name: String
    var emoji: String
    var entries: [ThreadEntry]
    
    init(name: String, emoji: String) {
        self.name = name
        self.emoji = emoji
        self.entries = []
    }
    
    func addEntry(threadEntry: ThreadEntry) {
        entries.append(threadEntry)
        
        let imageID = UUID.init().uuidString
        let dbThreadName = self.name
        
        let storageRef = storage.reference(withPath: "thread/\(imageID).jpg")
        let image = threadEntry.image
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        storageRef.putData(imageData)
        
        var ref: DocumentReference? = nil
        ref = db.collection("threads").addDocument(data: [
            "image": imageID,
            "thread name": dbThreadName
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print ("Document added with ID: \(ref!.documentID)")
            }
        }
    }
        
    
    func removeFirstEntry() -> ThreadEntry? {
        if entries.count > 0 {
            return entries.removeFirst()
        }
        return nil
    }
    
    func unreadCount() -> Int {
        return entries.count
    }
}

struct ThreadEntry {
    var username: String
    var image: UIImage
}

struct Post {
    var location: String
    var image: UIImage?
    var user: String
    var caption: String
    var date: Date
}

class FeedData {
    var username = "ap_es"
    
    var threads: [Thread] = [
        Thread(name: "memes", emoji: "😂"),
        Thread(name: "dogs", emoji: "🐶"),
        Thread(name: "fashion", emoji: "🕶"),
        Thread(name: "fam", emoji: "👨‍👩‍👧‍👦"),
        Thread(name: "tech", emoji: "💻"),
        Thread(name: "eats", emoji: "🍱"),
    ]

    // Adds dummy posts to the Feed
    var posts: [Post] = [
        Post(location: "New York City", image: UIImage(named: "skyline"), user: "nyerasi", caption: "Concrete jungle, wet dreams tomato 🍅 —Alicia Keys", date: Date()),
        Post(location: "Memorial Stadium", image: UIImage(named: "garbers"), user: "rjpimentel", caption: "Last Cal Football game of senior year!", date: Date()),
        Post(location: "Soda Hall", image: UIImage(named: "soda"), user: "chromadrive", caption: "Find your happy place 💻", date: Date())
    ]
    
    // Adds dummy data to each thread
    init() {
        for thread in threads {
            let entry = ThreadEntry(username: self.username, image: UIImage(named: "garbers")!)
            thread.addEntry(threadEntry: entry)
        }
    }
    
    func addPost(post: Post) {
        posts.append(post)
        
        let imageID = UUID.init().uuidString
        let dbLocation = post.location
        let dbUser = post.user
        let dbCaption = post.caption
        let dbDate = post.date
        
        let storageRef = storage.reference(withPath: "posts/\(imageID).jpg")
        if let image = post.image {
            guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
            let uploadMetadata = StorageMetadata.init()
            uploadMetadata.contentType = "image/jpeg"
            storageRef.putData(imageData)
        }
        
        var ref: DocumentReference? = nil
        ref = db.collection("posts").addDocument(data: [
            "image": imageID,
            "location": dbLocation,
            "user": dbUser,
            "caption": dbCaption,
            "date": dbDate,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print ("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    // Optional: Implement adding new threads!
    func addThread(thread: Thread) {
        threads.append(thread)
    }
    
/*    func fetch() {
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var imageID: String
                var location: String
                var user: String
                var caption: String
                var date: Date
                
                for document in querySnapshot!.documents {
                    imageID = document.data()["image"] as! String
                    location = document.data()["location"] as! String
                    user = document.data()["user"] as! String
                    caption = document.data()["caption"] as! String
                    date = document.data()["date"] as! Date
                    
                    let storageRef = storage.reference(withPath: "images/\(imageID).jpg")
                    
                    storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                        if error != nil {
                            print("error in retrieving data")
                        }
                        if let data = data {
                            let image = UIImage(data: data)
                            let savedPost = Post(location: location, image: image, user: user, caption: caption, date: date)
                            feed.addPost(post: savedPost)
                        }
                    }
                }
            }
        }
    }
 */
    
}
