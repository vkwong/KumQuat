//
//  LoginPage.swift
//  KumQuat
//
//  Created by labuser on 11/23/18.
//  Copyright © 2018 Vivian Wong. All rights reserved.
//

import UIKit

class LoginPage: UIViewController {
    
    var dbHandler: DBHandler!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userIcon = UIImage(named: "face-icon")
        addleftIcon(txtField: usernameInput, andImage: userIcon!)
        let passIcon = UIImage(named: "pass-icon")
        addleftIcon(txtField: passwordInput, andImage: passIcon!)
        passwordInput.isSecureTextEntry = true
        dbHandler = DBHandler()
//        dbHandler.dropTables()
        print(UserDefaults().integer(forKey: "id"))
    }
    
    func addleftIcon(txtField: UITextField, andImage img: UIImage) {
        
        let leftIcon = UIImageView(frame: CGRect(x: 5.0, y: 0.0, width: 20.0, height: 20.0))
        leftIcon.image = img
        txtField.leftView = leftIcon
        txtField.leftViewMode = .always
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func login(_ sender: UIButton) {
        let username = usernameInput.text!
        let password = passwordInput.text!
        let result = dbHandler.verifyUserPassLogin(user: username, pass: password)
        if result.count == 1 {
            UserDefaults.standard.set(result[0].id, forKey: "id")
            UserDefaults.standard.set(result[0].email, forKey: "email")
            UserDefaults.standard.set(result[0].username, forKey: "username")
            UserDefaults.standard.set(result[0].currentDorm, forKey: "dorm")
            UserDefaults.standard.set(result[0].currentCollege, forKey: "school")
            
            print("logged in as user \(result[0].id)")
            self.performSegue(withIdentifier: "loginSuccess", sender: self)
            
        } else {
            print("wrong login info")
            return
        }
    }
    
    
    @IBAction func signUpButton(_ sender: UIButton) {
        print("Button Pressed")
        self.performSegue(withIdentifier: "SignUpSegue", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
