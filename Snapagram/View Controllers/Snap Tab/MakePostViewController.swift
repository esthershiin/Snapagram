//
//  MakePostViewController.swift
//  Snapagram
//
//  Created by Allyson on 3/13/20.
//  Copyright © 2020 iOSDeCal. All rights reserved.
//

import UIKit

class MakePostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var threadCollectionView: UICollectionView!
    
    var imageToUpload: UIImage!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.isModalInPresentation = true
        imagePreview.image = imageToUpload
        threadCollectionView.delegate = self
        threadCollectionView.dataSource = self
        threadCollectionView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        threadCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.threads.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        let thread = feed.threads[index]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "threadCell", for: indexPath) as? ThreadCollectionViewCell {
            cell.threadEmojiLabel.text = thread.emoji
            cell.threadNameLabel.text = thread.name
            cell.threadUnreadCountLabel.text = String(thread.unreadCount())
            
            cell.threadBackground.layer.cornerRadius =  cell.threadBackground.frame.width / 2
            cell.threadBackground.layer.borderWidth = 3
            cell.threadBackground.layer.masksToBounds = true
            
            cell.threadUnreadCountLabel.layer.cornerRadius = cell.threadUnreadCountLabel.frame.width / 2
            cell.threadUnreadCountLabel.layer.masksToBounds = true
            
            if thread.unreadCount() == 0 {
                cell.threadUnreadCountLabel.alpha = 0
            } else {
                cell.threadUnreadCountLabel.alpha = 1
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // segue to preview controller with selected thread
        let chosenThread = feed.threads[indexPath.item]
        let newEntry = ThreadEntry(username: feed.username, image: imageToUpload)
        chosenThread.addEntry(threadEntry: newEntry)
        performSegue(withIdentifier: "uploadPostToFeed", sender: self)
    }
    
    @IBAction func newThreadButtonPressed(_ sender: Any) {
        // just realized that if we are going to allow users to add a new thread we need to have the user input the name and emoji of that new thread.. should we do that in a new view controller?
        // let newThread = Thread(name: <#T##String#>, emoji: <#T##String#>)
        // let newThreadEntry = ThreadEntry(username: feed.username, image: imageToUpload)
        // newThread.addEntry(threadEntry: newThreadEntry)
        // feed.addThread(newThread)
        // performSegue(withIdentifier: "uploadPostToFeed", sender: self)
    }
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        if let loc = locationTextField.text {
            if let cap = captionTextField.text {
                let newPost = Post(location: loc, image: imageToUpload, user: feed.username, caption: cap, date: Date())
                feed.addPost(post: newPost)
            }
        }
        performSegue(withIdentifier: "uploadPostToFeed", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? FeedViewController {
            dest.isModalInPresentation = true
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
