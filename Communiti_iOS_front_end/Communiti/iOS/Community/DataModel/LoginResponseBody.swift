//
//  LoginResponseBody.swift
//  Community
//
//  Created by Hatshit on 07/12/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginResponseBody: Mappable {
    var success: Bool?
    var message: String?
    var data:JsonData?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        success  <- map["success"]
        message  <- map["message"]
        data     <- map["data"]
    }
}
