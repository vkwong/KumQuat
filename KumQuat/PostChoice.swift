//
//  PostChoice.swift
//  
//
//  Created by labuser on 11/25/18.
//

import UIKit

class PostChoice: UIViewController {

    @IBOutlet weak var postType: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postType.layer.cornerRadius = 15
        postType.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func postAsVisible(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        //code here to set the user to be visible
    }
    
    @IBAction func postAsAnonymous(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        //code here to set the user to be anonymous
    }
}
