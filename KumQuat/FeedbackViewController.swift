//
//  FeedbackViewController.swift
//  database_demo
//
//  Created by Richard Kong on 11/29/18.
//  Copyright © 2018 Richard Kong. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    var q1_score: Int?
    var q2_score: Int?
    var q3_score: Int?
    var dbHandler: DBHandler!
    @IBOutlet weak var textview: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        q1_score = 5
        q2_score = 5
        q3_score = 5
        self.textview.layer.borderWidth = 1
        self.textview.layer.cornerRadius = 16
        dbHandler = DBHandler()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func q1(_ sender: UISlider) {
        q1_score = lroundf(sender.value)
    }
    @IBAction func q2(_ sender: UISlider) {
        q2_score = lroundf(sender.value)
    }
    @IBAction func q3(_ sender: UISlider) {
        q3_score = lroundf(sender.value)
    }
    
    @IBAction func submit(_ sender: Any) {
        if dbHandler.insertFeedback(q1: q1_score!, q2: q2_score!, q3: q3_score!, optional: textview.text){
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    //TODO: submit feedback to database
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
