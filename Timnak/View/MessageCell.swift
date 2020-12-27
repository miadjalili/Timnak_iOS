//
//  MessageCell.swift
//  Timnak
//
//  Created by miadjalili on 10/18/20.
//  Copyright © 2020 MIAD. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var viewMessageCell: UIView!
    @IBOutlet weak var textMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewMessageCell.layer.cornerRadius = viewMessageCell.frame.size.height / 15
        
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
