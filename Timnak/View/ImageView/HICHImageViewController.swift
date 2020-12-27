//
//  HICHImageViewController.swift
//  HichApp
//
//  Created by Sajjad Sarkoobi on 10/6/20.
//  Copyright © 2020 Scairp. All rights reserved.
//

import UIKit
import FontAwesome_swift

class HICHImageViewController: UIViewController {
  
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.dismissView()
    }
    
    @IBAction func shareBtnAction(_ sender: UIButton) {
        self.share()
    }
    
    @IBAction func swipeDownAction(_ sender: UISwipeGestureRecognizer) {
        self.dismissView()
    }
    
    private var image:UIImage
    private var imageView: ImageViewZoom!
    init(image:UIImage) {
        self.image = image
        super.init(nibName: "HICHImageViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.alpha = 0
        self.view.backgroundColor = UIColor.init(white: 0, alpha: 0)
        self.contentView.backgroundColor = .black
        
        self.closeBtn.setTitle("", for: .normal)
        let closeIcon = UIImage.fontAwesomeIcon(name: .times, style: .solid, textColor: .white, size: CGSize(width: 35, height: 35))
        self.closeBtn.setImage(closeIcon, for: .normal)
        self.closeBtn.layer.cornerRadius = self.closeBtn.frame.height / 2
        self.closeBtn.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        self.closeBtn.layer.borderWidth = 1.5
        self.closeBtn.layer.borderColor = UIColor.white.cgColor
        self.shareBtn.setTitle("", for: .normal)
               
               let shareicon = UIImage.fontAwesomeIcon(name: .shareAlt, style: .solid, textColor: .white, size: CGSize(width: 35, height: 35))
               self.shareBtn.setImage(shareicon, for: .normal)
        self.shareBtn.layer.cornerRadius = self.shareBtn.frame.height / 2
        self.shareBtn.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        self.shareBtn.layer.borderWidth = 1.5
        self.shareBtn.layer.borderColor = UIColor.white.cgColor

    }
    

    func presentImageView(presenter:UIViewController){
        
        self.modalPresentationStyle = .overFullScreen
        presenter.present(self, animated: false) {
            self.setupImageView()
            self.doPresenting()
        }
    }
    
    func dismissView(){
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.alpha = 0
            self.view.backgroundColor = UIColor.init(white: 0, alpha: 0)
        }) { (_) in
            self.dismiss(animated: false) {
                        self.imageView = nil
                }
        }

    }
    
    
    func setupImageView(){
        imageView = ImageViewZoom(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        imageView.setup()
        imageView.imageContentMode = .aspectFit
        imageView.initialOffset = .center
        imageView.display(image: image)
        imageView.alpha = 0

        self.contentView.addSubview(imageView)
        self.contentView.bringSubviewToFront(closeBtn)
        self.contentView.bringSubviewToFront(shareBtn)
    }
    
    private func doPresenting(){
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = UIColor.init(white: 0, alpha: 0.0)
            self.imageView.alpha = 1
            self.contentView.alpha = 1
            
        }

    }
    
    
    private func share(){
        let imageShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}


