//
//  SettingsViewController.swift
//  database_demo
//
//  Created by Richard Kong on 11/28/18.
//  Copyright © 2018 Richard Kong. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var id: Int?
    
    @IBOutlet weak var Username: UIButton!
    @IBOutlet weak var Email: UIButton!
    @IBOutlet weak var Password: UIButton!
    @IBOutlet weak var School: UIButton!
    @IBOutlet weak var Dorm: UIButton!
    
    
    let dbHandler: DBHandler = DBHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //TODO: suppose we have known username, email, school and dorm of the user.
        id = UserDefaults().integer(forKey: "id")
        
        Email.setTitle(UserDefaults().string(forKey: "email"), for: .normal)
        Username.setTitle(UserDefaults().string(forKey: "username"), for: .normal)
        School.setTitle(UserDefaults().string(forKey: "school"), for: .normal)
        Dorm.setTitle(UserDefaults().string(forKey: "dorm"), for: .normal)
        Password.setTitle(UserDefaults().string(forKey: "password"), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateUserName(_ sender: Any) {
        let name = UIAlertController(title: "New username", message: nil, preferredStyle: .alert)
        name.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        name.addTextField(configurationHandler: { textField in
            textField.placeholder = self.Username.currentTitle
        })
        name.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let user_name = name.textFields?.first?.text {
                if self.dbHandler.update(newData: user_name, id: self.id!, cond: 0){
                    self.Username.setTitle(user_name, for: .normal)
                } else {
                    self.updateUserName(self)
                }
            }
        }))
        self.present(name, animated: true)
    }
    
    @IBAction func updateEmail(_ sender: Any) {
        let email = UIAlertController(title: "New Email", message: nil, preferredStyle: .alert)
        email.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        email.addTextField(configurationHandler: { textField in
            textField.placeholder = self.Email.currentTitle
        })
        email.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let email_ = email.textFields?.first?.text {
                if self.dbHandler.update(newData: email_, id: self.id!, cond: 1) {
                    self.Email.setTitle(email_, for: .normal)
                } else {
                    self.updateEmail(self)
                }
            }
        }))
        self.present(email, animated: true)
    }
    
    @IBAction func updatePassword(_ sender: Any) {
        passwordAlert()
    }
    
    func passwordAlert() {
        let password = UIAlertController(title: "Change Password", message: nil, preferredStyle: .alert)
        password.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        password.addTextField(configurationHandler: { textField in
            textField.placeholder = "Please enter your old password."
            textField.isSecureTextEntry = true
        })
        password.addTextField(configurationHandler: { textField in
            textField.placeholder = "Please enter your new password."
            textField.isSecureTextEntry = true
        })
        password.addTextField(configurationHandler: { textField in
            textField.placeholder = "Please enter your new password again."
            textField.isSecureTextEntry = true
        })
        password.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            let users = self.dbHandler.readUsers(id: self.id!)
            for user in users {
                if user.password != password.textFields?.first?.text {
                    self.passwordAlert()
                }
                else {
                    if password.textFields![1].text != password.textFields![2].text {
                        self.passwordAlert()
                    }
                    else {
                        if let password_ = password.textFields?.last?.text {
                            self.Password.setTitle(password_, for: .normal)
                            self.dbHandler.update(newData: password_, id: self.id!, cond: 2)
                        }
                    }
                }
            }
        }))
        self.present(password, animated: true)
    }
    
    @IBAction func changeSchool(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChannelViewController") as? ChannelViewController
        vc?.cond = 0
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func changeDorm(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChannelViewController") as? ChannelViewController
        vc?.cond = 1
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you want to sign out?", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            //TODO: change the ViewController to the indentifier of the login view
            //TODO: empty current user infomation
            self.performSegue(withIdentifier: "signOut", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
        clearUserDefaults()        
    }
    
    func clearUserDefaults(){
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "dorm")
        UserDefaults.standard.removeObject(forKey: "school")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "username")
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to delete your account?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginPage")
            self.present(vc!, animated: true, completion: nil)
            
            //TODO: delete database
            if self.dbHandler.deleteUser(id: self.id!){
                self.clearUserDefaults()
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }

    @IBAction func back(_ sender: Any) {
        //TODO: change the ViewController to the indentifier of the previous view
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerHome")
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        let newSchool = School.titleLabel!.text!
        let newDorm = Dorm.titleLabel!.text!
        
        if dbHandler.update(newData: newDorm, id: id!, cond: 3){
            UserDefaults.standard.set(newDorm, forKey: "dorm")
        }
        
        if dbHandler.update(newData: newSchool, id: id!, cond: 4){
            UserDefaults.standard.set(newSchool, forKey: "school")
        }
        
    }
}
