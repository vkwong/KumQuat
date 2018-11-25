//
//  PostCellTableViewCell.swift
//  KumQuat
//
//  Created by labuser on 11/24/18.
//  Copyright © 2018 Vivian Wong. All rights reserved.
//

import UIKit

class PostCellTableViewCell: UITableViewCell {

    @IBOutlet weak var postContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(content: String) {
//        if content == nil {
//            content = "nil bitch"
//        }
        postContent.text = "fuck everything"
    }
    
    
    
    
}
