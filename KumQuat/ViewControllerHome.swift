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
    
    var userId: Int!
    var username: String!
    var userEmail: String!
    var userDorm: String!
    var userCollege: String!
    
//    var currentUser: User = User(id: 1, username: "vbach", email: "user@wustl.edu", password: "cskaMoskwa", dorm: "dorm1", college: "college1")
    
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var channelSwitch: UISegmentedControl!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var postMessage: UITextField!
    
    @IBAction func goToSettings(_ sender: UIButton) {
        performSegue(withIdentifier: "feedToSettings", sender: self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserData()


        let postCell = UINib(nibName: "PostCellTableViewCell", bundle: nil)
        feedTableView.register(postCell, forCellReuseIdentifier: "postCell")
        feedTableView.dataSource = self
        feedTableView.rowHeight = 100
        
//        dbHandler.dropTables()
                
        if channelSwitch.selectedSegmentIndex == 0 {
            posts = dbHandler.getAllCollegePosts(college: userCollege)
        } else {
            posts = dbHandler.getAllDormPosts(dorm: userDorm)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUserData()
        
        if channelSwitch.selectedSegmentIndex == 0 {
            posts = dbHandler.getAllCollegePosts(college: userCollege)
        } else {
            posts = dbHandler.getAllDormPosts(dorm: userDorm)
        }

        feedTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUserData(){
        userId = UserDefaults().integer(forKey: "id")
        username = UserDefaults().string(forKey: "username")
        userEmail = UserDefaults().string(forKey: "email")
        userDorm = UserDefaults().string(forKey: "dorm")
        userCollege = UserDefaults().string(forKey: "school")
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
            posts = dbHandler.getAllCollegePosts(college: userCollege)
            print("school channel")
        }
        else if (channel == 1) {
            posts = dbHandler.getAllDormPosts(dorm: userDorm)
            print("dorm channel")
        }
        
        feedTableView.reloadData()
    }
    
    
    @IBAction func submitPost(_ sender: Any) {
        performSegue(withIdentifier: "anonChoiceSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PostChoice{
            let message = postMessage.text!
            let userId = UserDefaults.standard.object(forKey: "id") as? Int ?? -1
            
            var postDorm = "n/a"
            var postCollege = "n/a"
            
            if channelSwitch.selectedSegmentIndex == 0{
                postCollege = UserDefaults.standard.object(forKey: "school") as? String ?? "n/a"
            } else {
                postDorm = UserDefaults.standard.object(forKey: "dorm") as? String ?? "n/a"
            }
            
            vc.table = feedTableView
            vc.dbHandler = dbHandler
            vc.message = message
            vc.authorId = userId
            vc.dorm = postDorm
            vc.college = postCollege
        } else {
            print("settings ")
            return
        }
    }
    
    
}
