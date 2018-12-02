//
//  PostChoice.swift
//  
//
//  Created by labuser on 11/25/18.
//

import UIKit

class PostChoice: UIViewController {
    var table: UITableView!
    var dbHandler: DBHandler!
    var message: String!
    var authorId: Int!
    var dorm: String!
    var college: String!
    
    @IBOutlet weak var postType: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postType.layer.cornerRadius = 15
        postType.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func postAsVisible(_ sender: UIButton) {
        if dbHandler!.createPost(author: authorId!, content: message!, dorm: dorm!, college: college!, locationShared: false, isAnon: false, timestamp: Int(NSDate().timeIntervalSince1970), parent_post: -1){
            
        }
        
        performSegue(withIdentifier: "visibleToFeed", sender: self)
    }
    
    @IBAction func postAsAnonymous(_ sender: UIButton) {
        if dbHandler!.createPost(author: authorId!, content: message!, dorm: dorm!, college: college!, locationShared: false, isAnon: true, timestamp: Int(NSDate().timeIntervalSince1970), parent_post: -1){
            
        }
        performSegue(withIdentifier: "anonToFeed", sender: self)
    }
}
