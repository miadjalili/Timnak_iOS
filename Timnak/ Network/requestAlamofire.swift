//
//  requestAlamofire.swift
//  Timnak
//
//  Created by miadjalili on 11/15/20.
//  Copyright © 2020 MIAD. All rights reserved.
//

import Foundation
import Alamofire

class request {
    
 let api = ""
 let apiUrl = "http://178.173.147.89:8088/testget/lesson/listlessonnames"
    
    func updateApi (apiUrl : String , ComplishiomHandelar : @escaping ([Modellessonname]) ->() ){
          
          let request = AF.request(apiUrl , method: .get)
              .validate()
          request.responseDecodable(of : [Modellessonname].self) { (response) in
           print(response)
              guard let requsetapi = response.value else {return}

              ComplishiomHandelar (

                 requsetapi
              )
          }

      }
    
// . post 
    
    
//       let request = AF.request(apiUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON {
//            response in
//
//            guard let requsetapi = response.value else {return}
//
//         ComplishiomHandelar (
//
//                 requsetapi
//               )
//
//            }
        }
        
  
    

