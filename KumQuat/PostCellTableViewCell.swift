//
//  PostCellTableViewCell.swift
//  KumQuat
//
//  Created by labuser on 11/24/18.
//  Copyright © 2018 Vivian Wong. All rights reserved.
//

import UIKit

class PostCellTableViewCell: UITableViewCell {
    
    var postId:Int!
    let currentUser: Int = UserDefaults.standard.integer(forKey: "id")
    var dbHandler: DBHandler!
    var viewController: ViewControllerHome!
    
    @IBOutlet weak var postContent: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var postScoreView: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var numberReplies: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(id: Int, author: String, content: String, score: Int, anonymous: Bool, num_replies: Int, timestamp: Int) {
        postContent.text = content
        if anonymous {
            authorLabel.text = "Anonymous"
        } else {
            authorLabel.text = author
        }
        postScoreView.text = String(score)
        postId = id
        if num_replies == 1{
            numberReplies.text = "1 reply"
        } else {
            numberReplies.text = "\(num_replies) replies"
        }
        let currentTime  = Int(NSDate().timeIntervalSince1970)
        self.timestamp.text = Util().convertUnixToHumanReadable(seconds: currentTime - timestamp) + " ago"
    }
    
    func setDatabaseHandler(handler: DBHandler){
        dbHandler = handler
    }
    
    func setViewController(vc: ViewControllerHome){
        viewController = vc
    }
    
    @IBAction func upvote(_ sender: UIButton) {
        if (currentUser != -1){
            if dbHandler.insertVote(postId: postId!, userId: currentUser, score: 1){
                print("added upvote to post \(postId!) from user \(currentUser)")
                viewController.feedTableView.reloadData()
            }
            
        } 
        
    }
    
    @IBAction func downvote(_ sender: UIButton) {
        if (currentUser != -1){
            if dbHandler.insertVote(postId: postId!, userId: currentUser, score: -1){
                print("added downvote to post \(postId!) from user \(currentUser)")
                viewController.feedTableView.reloadData()
            }
        }
    }
    
    @IBAction func reportPost(_ sender: UIButton) {
        if currentUser != -1 {
            if dbHandler.insertReport(postId: postId!, userId: currentUser){
                print("added report to post \(postId!) from user \(currentUser)")
                let alert = UIAlertController(title: "Report submitted", message: "Your report has been received.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                viewController.present(alert, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController(title: "Failed to submit report", message: "You have already reported this post.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                viewController.present(alert, animated: true, completion: nil)
                print("failed to add report to post \(postId!) from user \(currentUser)")
            }
        }
    }
    
    
    
}
