//
//  TableViewMicStuCell.swift
//  Timnak
//
//  Created by miadjalili on 10/18/20.
//  Copyright © 2020 MIAD. All rights reserved.
//

import UIKit
import SideMenu


class TableViewMicStuCell: UITableViewCell {

    @IBOutlet weak var IdentityStudent: UILabel!
    @IBOutlet weak var celMicStu: UIView!
    @IBOutlet weak var micBtnOnOff: UIButton!
    @IBOutlet weak var iconMicStu: UIImageView!
   
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
   /* @objc func buttonTapped ( sender: UIButton){
            
           if micBtnOnOff.backgroundColor == .clear {
                          micBtnOnOff.tintColor = .gray
                          
                    } else {
                  micBtnOnOff.backgroundColor = .clear
                  micBtnOnOff.tintColor = .red
                   
                              
                       }
                         
                         
                    }*/
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
