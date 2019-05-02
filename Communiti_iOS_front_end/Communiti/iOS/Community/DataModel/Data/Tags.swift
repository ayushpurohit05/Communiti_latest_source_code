//
//  Tags.swift
//  Community
//
//  Created by Hatshit on 11/12/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit
import ObjectMapper

class Tags: Mappable {

    
    var htag_id:String?
    var htag_text:String?
    var hTagStrLnth : Int = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        htag_id     <- map["htag_id"]
        htag_text  <- map["htag_text"]
        hTagStrLnth =  hTagStrLnth + (htag_text?.characters.count)!
    }

 

}
