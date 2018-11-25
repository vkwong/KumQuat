//
//  LoginPage.swift
//  KumQuat
//
//  Created by labuser on 11/23/18.
//  Copyright © 2018 Vivian Wong. All rights reserved.
//

import UIKit

class LoginPage: UIViewController {

    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        let userIcon = UIImage(named: "face-icon")
        addleftIcon(txtField: usernameInput, andImage: userIcon!)
        let passIcon = UIImage(named: "pass-icon")
        addleftIcon(txtField: passwordInput, andImage: passIcon!)
        // Do any additional setup after loading the view.
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
    

    @IBAction func loginButton(_ sender: UIButton) {
        print("login pressed")
        
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
