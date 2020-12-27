//
//  slideCell.swift
//  Timnak
//
//  Created by miadjalili on 10/31/20.
//  Copyright © 2020 MIAD. All rights reserved.
//

import UIKit
import AVFoundation
import SideMenu


protocol presentalert:AnyObject {
//    func present()
    func updateDataSource(index : Int , data : MessageModel)
    func updatecell()
    func imageFull(image: UIImage)
    func voiceSide(dataModel: MessageModel)
}


// MARK: - Main
class SlideCell: UITableViewCell, AVAudioRecorderDelegate{
    
    
    
   
    @IBOutlet weak var tableViewInCell: UITableView!
    @IBOutlet weak var ViewSlide: UIView!
    @IBOutlet weak var LongPress: UIButton!
    @IBOutlet weak var LargeImageBtn: UIButton!
    @IBOutlet weak var imageSlide: UIImageView!
    @IBOutlet weak var TimeLableForCell: UILabel!
    
    
    // MARK: - Variabels
   
    weak var delegate :presentalert?
    let session:AVAudioSession = AVAudioSession.sharedInstance()
    var audiocells : [AudioSlide] = []
    var numberOfRecord = 0
    var audioRecorder : AVAudioRecorder!
    var seconds = 0.0
    var timer = Timer()
    var isTimerRunning = false
    var audioPlayer : AVAudioPlayer!
    var playerItem : AVPlayerItem!
    var player : AVPlayer!
    var vc:UIViewController?
    var proprtyAudioCell : AudioCell?
    var index : Int = 0
    var dataModel: MessageModel = MessageModel()
    var filePathX : URL?
   

    

  
    
   
    
    
    
    
    @IBAction func LargeImageBtnAction(_ sender: Any) {
        
        delegate?.imageFull(image: imageSlide.image!)

    }
    
    
    @IBAction func slideVoice(_ sender: UIButton) {
        
        delegate?.voiceSide(dataModel: dataModel)
        
    }
    
    
    // MARK: - DidLoad(awakeFromNib)
    override func awakeFromNib() {
        super.awakeFromNib()
        tableViewInCell.isHidden = true
        tableViewInCell.backgroundColor = .clear
        tableViewInCell.separatorInset = UIEdgeInsets.zero
        
        TimeLableForCell.isHidden = true
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(press:)))
        longPress.minimumPressDuration = 0.4
        self.LongPress.addGestureRecognizer(longPress)
        tableViewInCell.register(UINib(nibName: "AudioCell", bundle: nil), forCellReuseIdentifier: "audioCell")
       // tableViewInCell.register(UINib(nibName: "AttachFileCell", bundle: nil), forCellReuseIdentifier: "attachFileCell")
        
       
        imageSlide.layer.cornerRadius = imageSlide.frame.size.height / 50
        
      
        designButton(uibutton: LongPress, borderWidth: 0)
        tableViewInCell.allowsSelection = false
//        tableViewInCell.delegate = self
//        tableViewInCell.dataSource = self
        tableViewInCell.reloadData()
        
        
        
        
        
        
        // Initialization code
    }
    
    
    func designButton(uibutton : UIButton,borderWidth: CGFloat){
        
        uibutton.backgroundColor = .white
        uibutton.layer.cornerRadius = 0.5 * uibutton.bounds.size.width
        uibutton.layer.shadowColor = UIColor(named: "buttonShadow")?.cgColor
        uibutton.layer.shadowOpacity = 0
        uibutton.layer.shadowOffset = CGSize(width: 1, height: 1)
        uibutton.layer.borderWidth = borderWidth
        uibutton.layer.borderColor = UIColor(named: "buttonBorder")?.cgColor
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    


 

// MARK: -TableView
//extension SlideCell :  UITableViewCell {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.dataModel.replies.count
//    }
//
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if !self.dataModel.replies.indices.contains(indexPath.row){
//            return UITableViewCell()
//        }
//        guard  let cell = tableViewInCell.dequeueReusableCell(withIdentifier: "audioCell", for:indexPath) as? AudioCell else{
//            return UITableViewCell()
//        }
//
//        let AudioSlid = self.dataModel.replies[indexPath.row]
//
////        if AudioSlid.body.contains("[AUDIO]"){
//            let msg = AudioSlid.body
//
//            let url = msg.replacingOccurrences(of: "[AUDIO]", with: "")
//            print(url)
//            print(URL(string: url)!)
//
//            cell.delegate = self
//            cell.filePath = URL(string: url)!
//            cell.backgroundColor = .clear
//
//            playAudioDuration(progressView: cell.progressAudio, TimeAudio: cell.TimeAudio, filePath: url)
//
//            let testView: UIView = UIView(frame: CGRect(x:0, y:0, width:tableViewInCell.frame.size.width , height:(cell.contentView.frame.size.height) - 5 ))
//            testView.layer.borderWidth = 0.2
//            testView.isUserInteractionEnabled = true
//            testView.layer.cornerRadius = testView.frame.size.height / 20
//
//            cell.contentView.addSubview(testView)
//            cell.contentView.sendSubviewToBack(testView)
//
//            return cell
            
//        }else
//        {
//            let cell = tableViewInCell.dequeueReusableCell(withIdentifier: "attachFileCell", for:indexPath) as! AttachFileCell
//            cell.AttachBubbel.layer.shadowColor = UIColor(named: "buttonShadow")?.cgColor
//            cell.AttachBubbel.layer.shadowOpacity = 0.8
//            cell.AttachBubbel.layer.shadowOffset = CGSize(width: 1, height: 1)
//            cell.layer.borderWidth = 0.8
//            cell.layer.cornerRadius = cell.frame.size.height / 9
//            return cell
//        }
        
        
        
  //  }
    
    
    
    
    
    
    // This Func Use For ReloadTableView
    func reloadTableView(){
        DispatchQueue.main.async {
            self.tableViewInCell.reloadData()
            if self.audiocells.count > 0 {
                let atIndex = (self.audiocells.count - 1)
                let index = IndexPath(item: atIndex, section: 0)
                self.tableViewInCell.scrollToRow(at: index, at: .bottom, animated: false)
            }
        }
    }
    
    
    
    // MARK: -LongPress
    // This Func Use for StartRecording & StopRecording
    @objc func longPress(press: UILongPressGestureRecognizer){
        
        if press.state == .began   {
            
            TimeLableForCell.isHidden = false
            LongPress.backgroundColor = .blue
            imageSlide.alpha = 0.4
            numberOfRecord += 1
            runTimer()
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            filePathX = getDirectory().appendingPathComponent("\(numberOfRecord).m4a")
            
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),AVSampleRateKey: 12000,AVNumberOfChannelsKey:1,AVEncoderAudioQualityKey:AVAudioQuality.low.rawValue]
            
            // startRecording
            do
            {
                audioRecorder = try AVAudioRecorder(url: filePathX!, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
            }catch
            {
                displayAleart(title: "ups!", message: "Recording Filed")
            }
            
            LongPress.tintColor = .blue
            
        }else if  press.state == .ended{
            tableViewInCell.isHidden = false
            TimeLableForCell.isHidden = true
            imageSlide.alpha = 1.0

            timer.invalidate()
            seconds = 0.0
            updateTimer()
            print("long endd")
            LongPress.backgroundColor = .white
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            //stop Recording
            audioRecorder.stop()
            self.dataModel.replies.append(AudioSlide.init(body: "[AUDIO]\(filePathX!)"))
            self.delegate?.updateDataSource(index: self.index, data: self.dataModel)
            
            delegate?.updatecell()
            if dataModel.replies.count <= 3 {
                tableViewInCell.isScrollEnabled = false
            }else{
                tableViewInCell.isScrollEnabled = true
            }
            
            reloadTableView()
         
          
        delegate?.voiceSide(dataModel: self.dataModel)

        }
        
    }
    
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(SlideCell.updateTimer)), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateTimer () {
        seconds += 1
        
        TimeLableForCell.text = timeString(time: TimeInterval(seconds))
        print(timeString(time: TimeInterval(seconds)))
        
    }
    
    // This Func for Convert Timer  to Correct Format
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    
    
    func getDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = path[0]
        return documentDirectory
    }
    
    // MARK: -PlayAudio
    // This Func For Play Audio
    func playAudio(filePath: URL,pogress:UIProgressView,playButton:UIButton){
        
        do {
            
            audioPlayer = try AVAudioPlayer(contentsOf: filePath)
            try session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            let timer = Timer.scheduledTimer(withTimeInterval: 0.0, repeats: true) { timer in
                if self.audioPlayer.isPlaying == true {
                    playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                    pogress.setProgress(Float(self.audioPlayer.currentTime/self.audioPlayer.duration), animated: true)
                    if playButton.isSelected == true{
                        self.audioPlayer.pause()
                    }
                   
                }
                else if self.audioPlayer.isPlaying == false
                {
                    pogress.setProgress(0.0, animated: true)
                    playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                    timer.invalidate()
                    
                }
            }
            
            
            audioPlayer.play()
            print("play\(audioPlayer.play())")
            print("paying\(audioPlayer.isPlaying)")
        } catch _ {
        }
    }
    
    
   
    
    
    
    func playAudioDuration(progressView:UIProgressView,TimeAudio : UILabel,filePath :String) {
        let url = URL(string: filePath)!
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            TimeAudio.text = timeString(time: audioPlayer.duration)
            
            progressView.setProgress(0.0, animated: true)
            
        }catch{
            
        }
        
        
    }
    
    
    func displayAleart(title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        vc?.present(alert, animated: true, completion: nil)
        
    }
    
}

// MARK: - PorotocolPlayAudio

extension SlideCell : audioCellDelegate,DocuFile {
    func addDocu(docPath: URL?) {
        self.dataModel.replies.append(AudioSlide.init(body: "[File]\(addDocu)"))
        reloadTableView()
        
      
    }
    
    func PlaayAudio(filePath: URL, progress: UIProgressView, playButton: UIButton) {
        playAudio(filePath: filePath,pogress: progress,playButton: playButton)
    }
    
   
    
    
}

// MARK: - PorotocolDocument


