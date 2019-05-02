//
//  HelpedUserList.swift
//  Community
//
//  Created by Hatshit on 11/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit
import ObjectMapper


class HelpedUserList: Mappable {
    
    
    var success: Bool?
    var message: String?
    var data:[UserListModel]?

    
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        success  <- map["success"]
        message  <- map["message"]
        data     <- map["data"]

    }
    

}
