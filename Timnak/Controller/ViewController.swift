//
//  ViewController.swift
//  Timnak
//
//  Created by miadjalili on 10/17/20.
//  Copyright © 2020 MIAD. All rights reserved.
//

import UIKit
import AVFoundation
import SideMenu
import MobileCoreServices


protocol DocuFile:AnyObject {
     func addDocu(docPath : URL?)
}
    
    
    
    
    
//MARK: -  Main
class ViewController: UIViewController,AVAudioRecorderDelegate{

    
    
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendMessageBtn: UIButton!
    @IBOutlet weak var LongPress: UIButton!
    @IBOutlet weak var liveVoiceBtn: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var MicStuBtn: UIButton!
    @IBOutlet weak var keyBordStuBtn: UIButton!
    @IBOutlet weak var attachBtn: UIButton!
    @IBOutlet weak var viewBarBtn: UIView!
    @IBOutlet weak var mainAttachFile: UIButton!
    
    @IBOutlet weak var testView: UIView!
    
    
    
    
    var micStuBtn : SideMenuNavigationController?
    var fileAttachSlide:SideMenuNavigationController?
   
    var messages : [MessageModel] = []
    weak var delegate :DocuFile?
    let screenSize:CGRect = UIScreen.main.bounds
    let customSideMenuManager = SideMenuManager()
    var url = request()//only for test api
    var Fiats = [Modellessonname]()//only for test api
    let camera = DKCamera()
    var dropUpView = Bundle.main.loadNibNamed("CameraFroStreaming", owner:self, options: nil)?.first as? CameraFroStreaming

    
    
    // This BTn Use For Send Message In Main TableView
    @IBAction func sendMessageBtn(_ sender: Any) {
        
        if  let msg = messageTextField.text  {
                  
               
              if !msg.isEmpty {
                messageTextField.frame.size.width = screenSize.width * 0.95
                sendMessageBtn.isHidden = true
                messages.append(MessageModel.init(body: msg, imageSlide: nil))
                reloadTableView()
                messageTextField.text = ""
               
            }
            }
 
        
    }
    

    @IBAction func MicStuBtn(_ sender: Any) {
        handelarmenue(Slider: micStuBtn)
        
    }
    
    
    @IBAction func mainAttachFileAction(_ sender: UIButton) {
        
        handelarmenue(Slider: fileAttachSlide)
        
    }
    
    
    
    //MARK: - DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        testView.isHidden = true
       
        print(TableView.contentInset)
        
        
        
        
        url.updateApi(apiUrl: url.apiUrl) { (response) in//only for test api
            self.Fiats = response//only for test api
            print("view did load:\(response)")//only for test api
            self.navigationItem.leftBarButtonItem?.title = " \(self.Fiats[0].LessonName)"    //only for test api
        }
        
       
        
        //self.messageTextField.adjustsFontSizeToFitWidth = true
        self.messageTextField.minimumFontSize = 12.0;
        messageTextField.frame.size.width = screenSize.width * 0.95
        
        LongPress.isHidden = true
        sendMessageBtn.isHidden = true
        TableView.allowsSelection = false
        
        
        viewBarBtn.layer.cornerRadius = viewBarBtn.frame.size.height / 8
        recordView.layer.cornerRadius = recordView.frame.size.height / 8
        
        viewBarBtn.layer.borderWidth = 0
        recordView.isHidden = true
        TableView.delegate = self
        TableView.dataSource = self
       
        TableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        TableView.register(UINib(nibName: "AudioCell", bundle: nil), forCellReuseIdentifier: "audioCell")
        TableView.register(UINib(nibName: "SlideCell", bundle: nil), forCellReuseIdentifier: "slideCell")
                
        
      
        let contoroler = self.storyboard?.instantiateViewController(withIdentifier: "micStuVC") as! MicStudentController
        micStuBtn = SideMenuNavigationController(rootViewController: contoroler)
        micStuBtn?.leftSide = true
        
       // attachFileVC
        
        let contorolerattach = self.storyboard?.instantiateViewController(withIdentifier: "attachFileVC") as! AttachFileController
        
        fileAttachSlide = SideMenuNavigationController(rootViewController: contorolerattach)
        fileAttachSlide?.leftSide = true
        fileAttachSlide?.sideMenuManager = customSideMenuManager
        
        
      
        
        
        
    
        
        liveVoiceBtn.tintColor = .gray
        liveVoiceBtn.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        keyBordStuBtn.addTarget(self, action: #selector(buttonKeyboardTapped(sender:)), for: .touchUpInside)
        messageTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)
        messageTextField.placeholder = "Type your Comment"
        
        
        designButton(uibutton: liveVoiceBtn, borderWidth: 0)
        designButton(uibutton: MicStuBtn, borderWidth: 0)
        designButton(uibutton: keyBordStuBtn, borderWidth: 0)
        designButton(uibutton: attachBtn, borderWidth: 0)
        designButton(uibutton: sendMessageBtn, borderWidth: 0)
        designButton(uibutton: LongPress, borderWidth: 0)
        

    }
    
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.isEditing == true  {
            messageTextField.frame.size.width = screenSize.width * 0.87
            sendMessageBtn.isHidden = false
            if messageTextField.text?.isEmpty == true {
                messageTextField.frame.size.width = screenSize.width * 0.95
                sendMessageBtn.isHidden = true
            }
        }
        
    }
    
    
    @objc func handelarmenue(Slider: SideMenuNavigationController?){
       
        
        present(Slider!, animated: true, completion: nil)
           }

}


//MARK: - TableView (Main)
extension ViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        if message.body.contains("[Slide]"){
            let cell = TableView.dequeueReusableCell(withIdentifier: "slideCell", for:indexPath) as! SlideCell
            cell.delegate = self
            cell.layer.borderWidth = 1.2
            cell.layer.cornerRadius = cell.frame.size.height / 90
            cell.frame.size.height = CGFloat(100.0)
            let msg = message.body
            let url = msg.replacingOccurrences(of: "[Slide]", with: "")
            cell.imageSlide.image = message.imageSlide
            cell.index = indexPath.row
           cell.dataModel = message
            return cell
            
        }
            
            
        else {
            let cell = TableView.dequeueReusableCell(withIdentifier: "messageCell", for:indexPath) as! MessageCell
            print("This ois Slide index\(indexPath.row)")
            cell.textMessageLabel.text = message.body
//            cell.textMessageLabel.frame = CGRect(x: 10.0 , y: 9.0, width: Double(message.body.count * 10), height: 41)
            
        
            
           // print(message.body.count)
            return cell
        }
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           let message = messages[indexPath.row]
           if message.body.contains("[Slide]"){
    }
    return UITableView.automaticDimension

    }
    
    
    
    // disPlayAleart
    func displayAleart(title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    


    // ReloadTableView
    func reloadTableView(){
        DispatchQueue.main.async {
            self.TableView.reloadData()
            if self.messages.count > 0 {
                let atIndex = (self.messages.count - 1)
                let index = IndexPath(item: atIndex, section: 0)
                self.TableView.scrollToRow(at: index, at: .bottom, animated: false)
            }
        }
    }
    
    
    
    
    // This Btn Use For Turn On/Off Live Steram
    @objc func buttonTapped ( sender: UIButton){
        
       if sender.isSelected  && dropUpView?.CameraView.isHidden == false  {
            
            print("Audio")
            
            
            let alert = UIAlertController(title: "Decision!", message: "Are you sure to disconnect the streaming?", preferredStyle: .alert)
            let action = UIAlertAction(title: "Disconnect Audio mode", style: .default) { (action) in
                sender.tintColor = .gray
                sender.isSelected = false
                
                self.dropUpView?.CameraView.isHidden = true
                self.TableView.contentInset = UIEdgeInsets(top: 0.0, left: 0, bottom: 0, right: 0)
            }
            alert.addAction(action)
            
            alert.addAction(UIAlertAction(title: "Not yet!", style: .cancel) { (action) in
            
            })
            present(alert,animated: true,completion: nil)
    
        
        }
        
        
        if sender.isSelected  && dropUpView?.CameraView.isHidden == true {
            print("Live")
            
            let alert = UIAlertController(title: "Decision!", message: "Are you sure to disconnect the streaming?", preferredStyle: .alert)
            let action = UIAlertAction(title: "Disconnect LIVE mode", style: .default) { (action) in
                sender.tintColor = .gray
                sender.isSelected = false
                self.testView.isHidden = true
                self.TableView.contentInset = UIEdgeInsets(top: 0.0, left: 0, bottom: 0, right: 0)
            }
            alert.addAction(action)
            
            alert.addAction(UIAlertAction(title: "Not yet!", style: .cancel) { (action) in
            
            })
            present(alert,animated: true,completion: nil)
            
            
        
        print( sender.isSelected  && dropUpView?.CameraView.isHidden == true)
        print(sender.isSelected )
       

     
    
        } else {
            
            print("Final")
             
           
            let alert = UIAlertController(title: "Decision!", message: "How to Communicate in Live Mode?", preferredStyle: .alert)
//            let action = UIAlertAction(title: "Only Audio Streaming", style: .default) { (action) in
//
//            }
            let action = UIAlertAction(title: "Video and Audio Streaming", style: .default) { (action) in
                 sender.tintColor = .red
                sender.isSelected = true
                self.dropUpView?.CameraView.isHidden = true
                
                self.camera.didCancel = {
                print("disconnect")
                    self.dismiss(animated: true, completion: nil)
                    
//               self.testView.isHidden = true
//                    self.testView.removeFromSuperview()
//                    sender.tintColor = .gray
//                    self.TableView.contentInset = UIEdgeInsets(top: 0.0, left: 0, bottom: 0, right: 0)
                    
                    
                               
                           }
               
                           
                           
                         //  camera.cameraOverlayView?.addSubview(testView)
                          // let cameraView = camera.cameraOverlayView
                self.testView.isHidden = false
                self.TableView.contentInset = UIEdgeInsets(top: self.testView.bounds.height + 5, left: 0, bottom: 0, right: 0)
                
                let new = self.camera.view
                new?.frame = CGRect(x: 9.0, y: 150.0, width: 393, height: 299)
                self.view.addSubview(new!)
//                self.camera.view.frame = CGRect(x: 0.0, y: 0.0, width: 393, height: 299)
//                self.view.addSubview(camera)
                
                self.camera.flashButton.isHidden = false
                self.camera.cameraSwitchButton.isHidden = false
               // self.present(camera, animated: true, completion: nil)
              self.camera.miniView = {
                
                
                
                self.camera.bottomViewContainer.isHidden = true
                self.camera.cameraSwitchButton.isHidden = true
                self.camera.flashButton.isHidden = true
                
            //   new!.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
                
                                 print("mini")
                                 
                                 
                                 
                             }
                 
                          // self.present(camera, animated: true, completion: nil)
            }
            
            
            alert.addAction(action)
            alert.addAction(UIAlertAction(title: "Only Audio Streaming", style: .default) { (action) in
           sender.tintColor = .red
           sender.isSelected = true
//                let viewAudio : UIView = {
//                     let viewAudio =  UIView()
//                    viewAudio.frame = CGRect(x: 9.0, y: 150.0, width: 393, height: 200)
//
//                    return viewAudio
//                }()
//
//                viewAudio.backgroundColor = .red
//                self.view.addSubview(viewAudio)
                self.TableView.contentInset = UIEdgeInsets(top: self.testView.bounds.height + 5, left: 0, bottom: 0, right: 0)
                self.dropUpView?.CameraView.isHidden = false
                self.view.addSubview((self.dropUpView?.CameraView)!)
                print(self.dropUpView?.DissconectBTn)
                if self.dropUpView?.DissconectBTn.isSelected == true{
                    print("diskm")
                    self.dropUpView?.CameraView.isHidden = true
                    
                    
                }
                
                
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        
            })
            present(alert,animated: true,completion: nil)
            
        }
        
    }
    
    
    
     // This Btn Use For Turn On/Off Students
    @objc func buttonKeyboardTapped ( sender: UIButton){
           if sender.isSelected {
            let imageOff = UIImage(named: "speaker_notes_off_black_108x108") as UIImage?
            sender.setImage(imageOff, for: .normal)
               let alert = UIAlertController(title: "Keybord Off!", message: "", preferredStyle: .alert)
               let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                   sender.isSelected = false
                   
               }
               alert.addAction(action)
               present(alert,animated: true,completion: nil)
               
               
           } else {
               let imageOn = UIImage(named: "speaker_notes_black_108x108") as UIImage?
               sender.setImage(imageOn, for: .normal)
               let alert = UIAlertController(title: "Keybord On!", message: "", preferredStyle: .alert)
               let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                   sender.isSelected = true
               }
               alert.addAction(action)
               present(alert,animated: true,completion: nil)
               
           }
           
       }
    

    
    
    // This use For Design button
    func designButton(uibutton : UIButton,borderWidth: CGFloat){
        
        uibutton.backgroundColor = UIColor(named: "buttonBackground")
        uibutton.layer.cornerRadius = 8
        uibutton.layer.shadowColor = UIColor(named: "buttonShadow")?.cgColor
        uibutton.layer.shadowOpacity = 0.0
        uibutton.layer.shadowOffset = CGSize(width: 1, height: 1)
        uibutton.layer.borderWidth = borderWidth
        uibutton.layer.borderColor = UIColor(named: "buttonBorder")?.cgColor
    }
    
 
     
    
    func sendMessage(Sendmessage : String){
        MessageModel.init(body: Sendmessage, imageSlide: nil)
    }
   
}




//MARK: -ImagePickerController

extension ViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIDocumentPickerDelegate{
  
    
    @IBAction func chooseSlide(_ sender: Any) {
        let imagePikerContoroller =  UIImagePickerController()
        
        imagePikerContoroller.delegate = self
       
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action : UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePikerContoroller.sourceType = .camera
                imagePikerContoroller.allowsEditing = true
                self.present(imagePikerContoroller, animated: true, completion: nil)
                
            }else{
                let alert = UIAlertController(title: "Camera Not Available", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                    
                }
                
                alert.addAction(action)
                self.present(alert,animated: true,completion: nil)
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Librery", style: .default, handler: { (action : UIAlertAction) in
            imagePikerContoroller.sourceType = .photoLibrary
            imagePikerContoroller.allowsEditing = true
            self.present(imagePikerContoroller, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancell", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.editedImage] as! UIImage
        
        messages.append(MessageModel.init(body: "[Slide]\(image)", imageSlide: image))
       
        reloadTableView()
       
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    

    
    
    
    
    
    
}

//MARK: - Protocol presentalert
extension ViewController : presentalert {
   


    
    func imageFull(image: UIImage) {
        let contoroller = HICHImageViewController(image: image)
        contoroller.presentImageView(presenter: self)
    }
   
    
    func updatecell() {
        TableView.reloadData()
    }
    
    func voiceSide(dataModel: MessageModel){
        
        let contorolerVoice = self.storyboard?.instantiateViewController(withIdentifier: "slideVoiceVC")as! SlideVoiceController
       
       
      
        contorolerVoice.datamodel(datamodel: dataModel)
//
        var voiceSlide:SideMenuNavigationController?
        
        
//       self.navigationController?.pushViewController(contorolerVoice, animated: true)
        
    
        
        voiceSlide = SideMenuNavigationController(rootViewController: contorolerVoice)

        voiceSlide?.leftSide = true
        voiceSlide?.menuWidth = 320.0
        handelarmenue(Slider: voiceSlide)
        
    }
    
    func updateDataSource(index: Int, data: MessageModel) {
        self.messages[index] = data
        DispatchQueue.main.async {
            self.reloadTableView()
        }
    }
    


}
    

