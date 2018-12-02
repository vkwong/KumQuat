//
//  ViewController.swift
//  KumQuat
//
//  Created by Vivian Wong on 11/15/18.
//  Copyright © 2018 Vivian Wong. All rights reserved.
//  https://www.simplifiedios.net/swift-sqlite-tutorial/


import UIKit
import SQLite3

class ViewController: UIViewController {
    
    var dbHandler: DBHandler!
    //var db: OpaquePointer?
    var userList = [User]()
    var dorm_choices: [String] = []
    var college: String!
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    


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
        
        if email!.hasSuffix("wustl.edu"){
            dorm_choices = Util.getDorms(college: .wustl)
            college = "Washington University in St. Louis"
        } else if email!.hasSuffix("slu.edu") {
            dorm_choices = Util.getDorms(college: .slu)
            college = "Saint Louis University"
        } else if email!.hasSuffix("webster.edu"){
            dorm_choices = Util.getDorms(college: .slu)
            college = "Webster University"
        } else {
            print("we dont have your school")
            return
        }
        
        if dbHandler.insertData(username: username!, password: password!, email: email!){
        
            let user = dbHandler.getUserFromUsername(username: username!)
            
            if  user.count == 1 {
                print("User saved successfully")
                UserDefaults.standard.set(user[0].id, forKey: "id")
                UserDefaults.standard.set(username!, forKey: "username")
                UserDefaults.standard.set(email!, forKey: "email")
                UserDefaults.standard.set(password!, forKey: "password")
                performSegue(withIdentifier: "pickDorm", sender: self)
            } else {
                print("user not found in table")
            }
        } else {
            print("failed to insert data")
        }
        
        textFieldUsername.text=""
        textFieldEmail.text=""
        textFieldPassword.text=""
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbHandler = DBHandler()
    }
    
    // referenced https://www.simplifiedios.net/swift-sqlite-tutorial/#Reading_Values

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DormChannel {
            vc.dorms = dorm_choices
            vc.college = college
        } else {
            return
        }
    }
    
    @IBAction func backToLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "cancelRegistration", sender: self)
    }
    
    
}

