//
//  AttachFileController.swift
//  Timnak
//
//  Created by miadjalili on 11/12/20.
//  Copyright © 2020 MIAD. All rights reserved.
//

import UIKit
import MobileCoreServices
class AttachFileController: UIViewController {

    
    
    
    
    
    
    @IBOutlet weak var attachFileTableView: UITableView!
    var urlFile : [String] = []
    var name:[String] = []
    
    
    
    

    func reloadTableView(){
        DispatchQueue.main.async {
            self.attachFileTableView.reloadData()
    //        if self.messages.count > 0 {
    //            let atIndex = (self.messages.count - 1)
    //            let index = IndexPath(item: atIndex, section: 0)
    //            self.TableView.scrollToRow(at: index, at: .bottom, animated: false)
    //        }
        }
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("slider")
        navigationItem.title = "Upload Files"
        
       
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AttachFileController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlFile.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
      let cell = attachFileTableView.dequeueReusableCell(withIdentifier: "attachFileCell", for:indexPath) as! attachFileCell
        
        cell.numberOfRow.text = " \(indexPath.row + 1). "
        
        
        
        
       cell.fileNameLable.text =  name[indexPath.row]
        
        
        return cell
    }


}









extension AttachFileController :UINavigationControllerDelegate,UIDocumentPickerDelegate,UIImagePickerControllerDelegate{
    
    
    func clickFunction(){
              let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet,kUTTypeJPEG,kUTTypeGIF]
              let importMenu = UIDocumentPickerViewController(documentTypes: types as [String], in: .open)
               importMenu.delegate = self
           
              importMenu.modalPresentationStyle = .formSheet
              self.present(importMenu, animated: true, completion: nil)
          }
       
       @IBAction func UplodFileAttachActhion(_ sender: UIButton) {
           
               let imagePikerContoroller =  UIImagePickerController()
        imagePikerContoroller.delegate = self
               let actionSheet = UIAlertController(title: "Choose File", message: "You Can Choose File : .PDF,.TEXT,..." , preferredStyle: .actionSheet)
               
               actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action : UIAlertAction) in
                          UIImagePickerController.isSourceTypeAvailable(.camera)
                          imagePikerContoroller.sourceType = .camera
                          imagePikerContoroller.allowsEditing = true
                
                        self.present(imagePikerContoroller,animated: true,completion: nil)
               }))
               
              
               actionSheet.addAction(UIAlertAction(title: "Document", style: .default, handler: { (action : UIAlertAction) in
               
                    self.clickFunction()
                  
                   
               }))
               actionSheet.addAction(UIAlertAction(title: "Photo Librery", style: .default, handler: { (action : UIAlertAction) in
                                 imagePikerContoroller.sourceType = .photoLibrary
                                 imagePikerContoroller.allowsEditing = true
                                 self.present(imagePikerContoroller, animated: true, completion: nil)
                             }))
                        
               
               actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
               self.present(actionSheet, animated: true, completion: nil)
           }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.editedImage] as! UIImage
        
        print("\(image)")
        picker.dismiss(animated: true, completion: nil)
        var textfield = UITextField()
        let alert  = UIAlertController(title: "Add Name For File", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Name", style: .default) { (action) in
            if textfield.text?.isEmpty == false{
                self.urlFile.append("\(image)")
                self.name.append("\(textfield.text!)")
                self.reloadTableView()
            }else{
                let alert = UIAlertController(title: "FileName is Empty", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                }
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
                
            }
            print(self.urlFile)
        }
        alert.addTextField { (alerttextFiled) in
            alerttextFiled.placeholder = "Flie Name"
            textfield = alerttextFiled
            
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
        
        reloadTableView()
        
        
        
        
        
    }
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       
           picker.dismiss(animated: true, completion: nil)
       }
    
    
    
    
    
    
    
       func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            let myURL = urls.first
     var textfield = UITextField()
        let alert  = UIAlertController(title: "Add Name For File", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Name", style: .default) { (action) in
            if textfield.text?.isEmpty == false{
            self.urlFile.append("\(myURL!)")
            self.name.append("\(textfield.text!)")
            self.reloadTableView()
            }else{
                let alert = UIAlertController(title: "FileName is Empty", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                }
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
                
            }
            print(self.urlFile)
        }
        alert.addTextField { (alerttextFiled) in
            alerttextFiled.placeholder = "Flie Name"
            textfield = alerttextFiled
            
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
        
        
        
        
                      return
              
          }
    
    
    
}
