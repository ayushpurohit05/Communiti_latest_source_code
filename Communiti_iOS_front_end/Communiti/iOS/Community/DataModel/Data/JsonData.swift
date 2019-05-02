//
//  JsonData.swift
//  Community
//
//  Created by Hatshit on 07/12/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit
import ObjectMapper
import Firebase
class JsonData: Mappable{

    // Login Api Keys
    var profile_image:String?
    var usr_createddate:String?
    var usr_dob:String?
    var usr_email:String?
    var usr_fname:String?
    var usr_gender:String?
    var usr_id:String?
    var usr_lname:String?
    var usr_token:String?
    var usr_updatedate:String?
    var data: [ChatHomeDataModel]?
    var total_count: String?
    
    
    
    
    
  
    
//    // for logout
//    var user_fbDetails:String?
//    var user_gmailDetails:String?
//    var user_instaDetails:String?
//    var user_twiteDetails:String?
    
    
    //var bs:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        // Login Api Keys
        profile_image     <- map["profile_image"]
        usr_createddate  <- map["usr_createddate"]
        usr_dob  <- map["usr_dob"]
        usr_email  <- map["usr_email"]
        usr_fname  <- map["usr_fname"]
        usr_gender  <- map["usr_gender"]
        usr_id  <- map["usr_id"]
        usr_lname  <- map["usr_lname"]
        usr_token  <- map["usr_token"]
        usr_updatedate  <- map["usr_updatedate"]
        
        
        data  <- map["data"]
        total_count  <- map["total_count"]
     
//        user_fbDetails  <- map["user_fbDetails"]
//        user_gmailDetails  <- map["user_gmailDetails"]
//        user_instaDetails  <- map["user_instaDetails"]
//        user_twiteDetails  <- map["user_twiteDetails"]
        
    }

    
}//END
