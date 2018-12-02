//
//  ViewControllerHome.swift
//  KumQuat
//
//  Created by Vivian Wong on 11/19/18.
//  Copyright © 2018 Vivian Wong. All rights reserved.
//

import Foundation

import UIKit
import SQLite3

class ViewControllerHome: UIViewController, UITableViewDataSource {
    let dbHandler: DBHandler = DBHandler()
    var posts: [Post] = [] {
        didSet {
            feedTableView.reloadData()
        }
    }

    
    var currentUser: User = User(id: 1, username: "vbach", email: "user@wustl.edu", password: "cskaMoskwa", dorm: "dorm1", college: "college1")
    
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var channelSwitch: UISegmentedControl!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var postMessage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(currentUser.id, forKey: "UserID")
        UserDefaults.standard.set(currentUser.currentDorm, forKey: "UserDorm")
        UserDefaults.standard.set(currentUser.currentCollege, forKey: "UserCollege")
        // Do any additional setup after loading the view, typically from a nib.
        
//
//        print(dbHandler.insertData(username: "vbach", password: "324567hgfdd", email: "xxx@wustl.edu"))

        let postCell = UINib(nibName: "PostCellTableViewCell", bundle: nil)
        feedTableView.register(postCell, forCellReuseIdentifier: "postCell")
        feedTableView.dataSource = self
        feedTableView.rowHeight = 100
        
//        dbHandler.dropTables()
        
        
        if channelSwitch.selectedSegmentIndex == 0 {
            posts = dbHandler.getAllCollegePosts(college: currentUser.currentCollege!)
        } else {
            posts = dbHandler.getAllDormPosts(dorm: currentUser.currentDorm!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if channelSwitch.selectedSegmentIndex == 0{
            posts = dbHandler.getAllCollegePosts(college: currentUser.currentCollege!)
        } else {
            posts = dbHandler.getAllDormPosts(dorm: currentUser.currentDorm!)
        }
        
        feedTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCellTableViewCell
        
        let post_id = posts[indexPath.row].id
        let content = posts[indexPath.row].content
        let author = posts[indexPath.row].author
        let anonymous = posts[indexPath.row].isAnon
        let score = dbHandler.getPostScore(postId: posts[indexPath.row].id)
        let num_replies = dbHandler.getReplies(postId: post_id).count
        let timestamp = posts[indexPath.row].timestamp
        cell.configureCell(id: post_id, author: author!, content: content!, score: score, anonymous: anonymous, num_replies: num_replies, timestamp: timestamp)
        cell.setDatabaseHandler(handler: dbHandler)
        cell.setViewController(vc: self)
        
        return cell

    }
    
    
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        let channel = channelSwitch.selectedSegmentIndex
        if (channel == 0) {
            posts = dbHandler.getAllCollegePosts(college: currentUser.currentCollege!)
            print("school channel")
        }
        else if (channel == 1) {
            posts = dbHandler.getAllDormPosts(dorm: currentUser.currentDorm!)
            print("dorm channel")
        }
        
        feedTableView.reloadData()
    }
    
    
    @IBAction func submitPost(_ sender: Any) {
        performSegue(withIdentifier: "anonChoiceSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc : PostChoice = segue.destination as! PostChoice
        let message = postMessage.text!
        let userId = UserDefaults.standard.object(forKey: "UserID") as? Int ?? -1
        
        var dorm = "n/a"
        var college = "n/a"
        
        if channelSwitch.selectedSegmentIndex == 0{
            college = UserDefaults.standard.object(forKey: "UserCollege") as? String ?? "n/a"
        } else {
            dorm = UserDefaults.standard.object(forKey: "UserDorm") as? String ?? "n/a"
        }
        
        vc.table = feedTableView
        vc.dbHandler = dbHandler
        vc.message = message
        vc.authorId = userId
        vc.dorm = dorm
        vc.college = college
    }
    
    
}
