//
//  MicStudentController.swift
//  Timnak
//
//  Created by miadjalili on 10/18/20.
//  Copyright © 2020 MIAD. All rights reserved.
//

import UIKit

class MicStudentController: UIViewController{

    @IBOutlet var TableViewMicStu: UITableView!
  
    
    
    
    let identity = ["ali","hossin","mohammad","javad","Nader","majid","Hadi","Reza","Sajjad","Mohsen","Amir","Adrian","Miad","Miad","Armin","Nader","Reza","hossin","Sajjad","ali"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        navigationItem.title = "Microphone Student"
   
        // Do any additional setup after loading the view.
    
                
                 }

    
}



extension MicStudentController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return identity.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cellMicStu", for: indexPath) as! TableViewMicStuCell
        
        cell.IdentityStudent.text = identity[indexPath.row]
        
        cell.iconMicStu.isHidden = true
        cell.micBtnOnOff.tintColor = .gray
        cell.micBtnOnOff.tag = indexPath.row
        cell.micBtnOnOff.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            
    
        if indexPath.row == 2 {
            cell.iconMicStu.isHidden = false
            
        }
        
        
        
        
        return cell
    }
    @objc func buttonTapped ( sender: UIButton){
        print(sender.tag)
        sender.isSelected = !sender.isSelected
        sender.tintColor = sender.isSelected ? .red : .gray
        
//        if sender.isSelected{
//            sender.tintColor = .gray
//            sender.isSelected = false
//        }else{
//            sender.tintColor = .red
//            sender.isSelected = true
//        }
      
    }
    
    
}
  


