//
//  ViewController.swift
//  KumQuat
//
//  Created by Vivian Wong on 11/15/18.
//  Copyright © 2018 Vivian Wong. All rights reserved.
//  https://www.simplifiedios.net/swift-sqlite-tutorial/


import UIKit
import SQLite3

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dbHandler: DBHandler!
    //var db: OpaquePointer?
    var userList = [User]()
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var tableViewUsers: UITableView!
    
    // For Users table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerUserTableViewCell
        
        let user: User
        user = userList[indexPath.row]
        
        cell.labelUsername.text = user.username
            //! + ", " + user.email! + ", " + user.password!
        
        return cell
    }
    
    // Saves email, username, password into Users table - register new user-
    @IBAction func buttonRegisterUser(_ sender: Any) {
        //saving
        let username = textFieldUsername.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = textFieldEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = textFieldPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //TODO: check to see if username already exists
        if ((!(email?.hasSuffix(".edu"))!)) {
            //registerButton.isEnabled = false
            print("Need valid .edu email to register")
            textFieldEmail.layer.borderColor = UIColor.red.cgColor
            return
        }
        if (email?.isEmpty)! {
            textFieldEmail.layer.borderColor = UIColor.red.cgColor
            print("Email is required")
            return
        }
        if (username?.isEmpty)! {
            textFieldUsername.layer.borderColor = UIColor.red.cgColor
            print("Username is required")
            return
        }
        if (password?.isEmpty)! {
            textFieldPassword.layer.borderColor = UIColor.red.cgColor
            print("Password is required")
            return
        }
        
        let arr = dbHandler.readUsers(condition: username!)
        if !arr.isEmpty {
            print("user has existed")
            return
        }
        
        if dbHandler.insertData(username: username!, password: password!, email: email!) {
            print(username!)
            print(email!)
            print(password!)
            print("User saved successfully")
        } else {
            print("fail to insert data")
        }
        
        textFieldUsername.text=""
        textFieldEmail.text=""
        textFieldPassword.text=""
        
        //go to home page
        let home = ViewControllerHome()
        navigationController?.pushViewController(home, animated: true)
        print("You have logged in")
        
        self.performSegue(withIdentifier: "loginSegueIdentifier", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dbHandler = DBHandler()

//        if dbHandler.createPost(author: "Bartek", content: "fuck", dorm: "Porter", college: "Beloit College", locationShared: true, isAnon: false, parent_post: -1){
//            print("post added")
//        }else {
//            print("post not added")
//        }

//        Examples
//        let postsEx1 = dbHandler.getAllPosts()
//        let postsEx2 = dbHandler.getAllCollegePosts(college: "Kalamazoo College")
//        let postsEx3 = dbHandler.getAllDormPosts(dorm: "Hall1")
//
//        for p in postsEx1 {
//            print(p.toString())
//        }
    
    }
    
    // referenced https://www.simplifiedios.net/swift-sqlite-tutorial/#Reading_Values

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

