//
//  PostReplyViewController.swift
//  KumQuat
//
//  Created by labuser on 12/1/18.
//  Copyright © 2018 Vivian Wong. All rights reserved.
//

import UIKit

class PostReplyViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var postMessage: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var score: UILabel!
    
    var dbHandler: DBHandler!
    var parentPost: Post!
    var replies: [Post]! {
        didSet {
            childTableView.reloadData()
        }
    }
    
    var currentUserId: Int!
    
    
    @IBOutlet weak var childTableView: UITableView!
    
    @IBOutlet weak var replyMessage: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        dbHandler = DBHandler()
        let replyCell = UINib(nibName: "ChildCell", bundle: nil)
        childTableView.register(replyCell, forCellReuseIdentifier: "replyCell")
        childTableView.dataSource = self

        currentUserId = UserDefaults.standard.integer(forKey: "id")
        updateParentPost()
        replies = dbHandler.getReplies(postId: parentPost.id)
        childTableView.rowHeight = 100
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func reportPost(_ sender: UIButton) {
        if currentUserId != -1 {
            if dbHandler.insertReport(postId: parentPost.id, userId: currentUserId){
                let alert = UIAlertController(title: "Report submitted", message: "Your report has been received.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController(title: "Failed to submit report", message: "You have already reported this post.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func downvoteButton(_ sender: UIButton) {
        if (currentUserId != -1){
            if dbHandler.insertVote(postId: parentPost.id, userId: currentUserId, score: -1){
                updateParentPost()
            }
        }
    }
    
    @IBAction func upvoteButton(_ sender: UIButton) {
        if (currentUserId != -1){
            if dbHandler.insertVote(postId: parentPost.id, userId: currentUserId, score: 1){
                updateParentPost()
            }
        }
    }
    @IBAction func replySendBtn(_ sender: UIButton) {
        if replyMessage.text!.count > 3 {
            if dbHandler!.createPost(author: currentUserId!, content: replyMessage.text!, dorm: parentPost.dorm!, college: parentPost.college!, locationShared: false, isAnon: true, timestamp: Int(NSDate().timeIntervalSince1970), parent_post: parentPost.id){
                replies = dbHandler.getReplies(postId: parentPost.id)
                childTableView.reloadData()
                replyMessage.text! = ""
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = childTableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath) as! ChildCell
        
        let post_id = replies[indexPath.row].id
        let content = replies[indexPath.row].content
        let author = replies[indexPath.row].author
        let anonymous = replies[indexPath.row].isAnon
        let score = dbHandler.getPostScore(postId: replies[indexPath.row].id)
        let timestamp = replies[indexPath.row].timestamp
        
        cell.configureCell(id: post_id, author: author!, content: content!, score: score, anonymous: anonymous, timestamp: timestamp)
        cell.setDatabaseHandler(handler: dbHandler)
        cell.setViewController(vc: self)
        
        return cell
    }
    
    func updateParentPost(){
        if parentPost.isAnon {
            author.text = "Anonymous"
        } else {
            author.text = parentPost.author
        }
        
        postMessage.text = parentPost.content
        let secs = Int(NSDate().timeIntervalSince1970) - parentPost.timestamp
        timestamp.text = Util().convertUnixToHumanReadable(seconds: secs) + " ago"
        
        let post_score = dbHandler.getPostScore(postId: parentPost.id)
        
        if post_score == 0 {
            score.text = "0"
        } else {
            score.text = String(post_score)
        }
    }
    


}
