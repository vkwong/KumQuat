//
//  ChannelViewController.swift
//  database_demo
//
//  Created by Richard Kong on 11/29/18.
//  Copyright © 2018 Richard Kong. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var ChannelTableView: UITableView!
    
    var channelSchool: [String] = []
    
    var channelDorm: [String] = []
    
    var school: String?
    var cond = Int()
    var dbHandler: DBHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbHandler = DBHandler()
        ChannelTableView.layer.cornerRadius = 10
        ChannelTableView.layer.masksToBounds = true
        
        channelSchool = Util.getColleges()
        school = UserDefaults.standard.string(forKey: "school")
        if school == "Washington University in St. Louis" {
            channelDorm = Util.getDorms(college: .wustl)
        } else if school == "Webster University" {
            channelDorm = Util.getDorms(college: .webster)
        } else if school == "Saint Louis University" {
            channelDorm = Util.getDorms(college: .slu)
        }
        
        ChannelTableView.dataSource = self
        ChannelTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cond == 0 {
            return channelSchool.count
        } else {
            return channelDorm.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if cond == 0 {
            myCell.textLabel!.text = channelSchool[indexPath.row]
        } else {
            myCell.textLabel!.text = channelDorm[indexPath.row]
        }
        myCell.textLabel!.textColor = UIColor.white
        myCell.backgroundColor = UIColor.orange
        return myCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cond == 0 {
            UserDefaults().set(channelSchool[indexPath.row], forKey: "school")
        } else {
            UserDefaults().set(channelDorm[indexPath.row], forKey: "dorm")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.present(vc, animated: false, completion: nil)
    }
}
