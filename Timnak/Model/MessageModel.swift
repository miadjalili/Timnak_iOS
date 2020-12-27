//
//  Message.swift
//  Timnak
//
//  Created by miadjalili on 10/18/20.
//  Copyright © 2020 MIAD. All rights reserved.
//

import Foundation
import UIKit

struct MessageModel {
   // let sender : String
    var body: String
    var imageSlide : UIImage?
    var replies : [AudioSlide] = []
    
    init(body : String = "", imageSlide : UIImage? = nil , replies: [AudioSlide] = []) {
        self.body = body
        self.imageSlide = imageSlide
        self.replies = replies
    }
    
}

struct AudioSlide {
    let body: String
}

