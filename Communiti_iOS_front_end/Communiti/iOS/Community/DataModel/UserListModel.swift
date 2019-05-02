//
//  UserListModel.swift
//  Community
//
//  Created by Hatshit on 11/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit
import ObjectMapper

class UserListModel: NSObject, Mappable {

    // for get User List in HelpReqDetailsVC
    var hlp_completed:String?
    var hlp_id:String?
    var profile_image:String?
    var usr_fname:String?
    var usr_id:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
   
        // for get User List in HelpReqDetailsVC
        hlp_completed  <- map["hlp_completed"]
        hlp_id  <- map["hlp_id"]
        profile_image  <- map["profile_image"]
        usr_fname  <- map["usr_fname"]
        usr_id  <- map["usr_id"]
        
    }

 
}
