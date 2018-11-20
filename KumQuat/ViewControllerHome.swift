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

class ViewControllerHome: UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*let dbHandler: DBHandler = DBHandler()
        
        print(dbHandler.insertData(username: "erer", password: "324567hgfdd", email: "xxx@wustl.edu"))
        print(dbHandler.insertData(username: "xiaoerer", password: "hgf34gf", email: "aaa@wustl.edu"))
        
        let a = dbHandler.readUsers(condition: "erer")
        for i in a {
            print(i.email)
        }
        
        print(dbHandler.update(password: "a", condition: "erer"))*/
        
        print("LOG IN SUCCESSFUL")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
