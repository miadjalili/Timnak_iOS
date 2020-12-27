//
//  SlideVoiceTableViewCell.swift
//  Timnak
//
//  Created by miadjalili on 11/19/20.
//  Copyright © 2020 MIAD. All rights reserved.
//

import UIKit



protocol audioCellDelegate:AnyObject {
    func PlaayAudio(filePath : URL,progress: UIProgressView,playButton:UIButton)
}


class SlideVoiceTableViewCell: UITableViewCell {
    weak var delegate :audioCellDelegate?
       var filePath : URL?
    
    
    
    
    
    
       @IBOutlet weak var audioBubbl: UIView!
       @IBOutlet weak var progressAudio: UIProgressView!
       @IBOutlet weak var playAudioBtn: UIButton!
       @IBOutlet weak var TimeAudio: UILabel!
       @IBAction func playBtnAction(_ sender: UIButton) {
           
               sender.imageView?.image = UIImage(named: "pause,fill")
        
             print("okk\(filePath)")
               if let url = filePath{
                   delegate?.PlaayAudio(filePath: url, progress: progressAudio, playButton: playAudioBtn)
                
               }

          
           

       }
       
    
    
    
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
