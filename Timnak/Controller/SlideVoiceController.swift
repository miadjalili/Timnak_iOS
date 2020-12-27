//
//  SlideVoiceController.swift
//  Timnak
//
//  Created by miadjalili on 11/19/20.
//  Copyright © 2020 MIAD. All rights reserved.
//

import UIKit
import AVFoundation






class SlideVoiceController: UIViewController {
    
    @IBOutlet weak var voiceTableView: UITableView!
    
    var dataModell: MessageModel = MessageModel()
    
    
    func datamodel(datamodel : MessageModel )   {
        
       
      dataModell.replies.append(contentsOf: datamodel.replies)
        
 
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    navigationItem.title = "voices"

     
        print(dataModell.replies.count)
        print(dataModell.replies)
        
   
        
       
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
     // reloadTableView()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func reloadTableView(){
           DispatchQueue.main.async {
               self.voiceTableView.reloadData()
              
                   
               }
           }
    

}
extension SlideVoiceController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModell.replies.count
       
    }

    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = voiceTableView.dequeueReusableCell(withIdentifier: "slideVoiceCell", for:indexPath) as! SlideVoiceTableViewCell
        
        
        let testView: UIView = UIView(frame: CGRect(x:0, y:0, width:voiceTableView.frame.size.width , height:(cell.contentView.frame.size.height) - 5 ))
        testView.layer.borderWidth = 0.2
        testView.isUserInteractionEnabled = true
        testView.layer.cornerRadius = testView.frame.size.height / 5
        
        cell.contentView.addSubview(testView)
        cell.contentView.sendSubviewToBack(testView)
        
        
        return cell
    }
    
}


