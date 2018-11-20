//
//  ViewControllerUserTableViewCell.swift
//  KumQuat
//
//  Created by Vivian Wong on 11/19/18.
//  Copyright © 2018 Vivian Wong. All rights reserved.
//

import UIKit

class ViewControllerUserTableViewCell: UITableViewCell {

    @IBOutlet weak var labelUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
