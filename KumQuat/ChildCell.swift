//
//  ChildCell.swift
//  
//
//  Created by labuser on 11/25/18.
//

import UIKit

class ChildCell: UITableViewCell {


    @IBOutlet weak var authorReply: UILabel!
    
    @IBOutlet weak var scoreReply: UILabel!
    @IBOutlet weak var textReply: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    
    var postId: Int!
    var dbHandler: DBHandler!
    var viewController: PostReplyViewController!
    var currentUser: Int! = UserDefaults.standard.integer(forKey: "id")
    


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(id: Int, author: String, content: String, score: Int, anonymous: Bool, timestamp: Int) {
        textReply.text = content
        if anonymous {
            authorReply.text = "Anonymous"
        } else {
            authorReply.text = author
        }
        scoreReply.text = String(score)
        postId = id
        let currentTime  = Int(NSDate().timeIntervalSince1970)
        self.timestamp.text = Util().convertUnixToHumanReadable(seconds: currentTime - timestamp) + " ago"
    }
    
    func setDatabaseHandler(handler: DBHandler){
        dbHandler = handler
    }
    
    func setViewController(vc: PostReplyViewController){
        viewController = vc
    }


    @IBAction func reportReply(_ sender: UIButton) {
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
    

    @IBAction func downvoteReply(_ sender: UIButton) {
        if (currentUser != -1){
            if dbHandler.insertVote(postId: postId!, userId: currentUser, score: -1){
                print("added downvote to post \(postId!) from user \(currentUser)")
                viewController.childTableView.reloadData()
            }
        }
    }


    @IBAction func upvoteReply(_ sender: UIButton) {
        if (currentUser != -1){
            if dbHandler.insertVote(postId: postId!, userId: currentUser, score: 1){
                print("added upvote to post \(postId!) from user \(currentUser)")
                viewController.childTableView.reloadData()
            }
            
        } 
    }
}
