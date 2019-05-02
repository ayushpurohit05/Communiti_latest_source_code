//
//  CountryResponseBody.swift
//  Community
//
//  Created by Hatshit on 09/12/17.
//  Copyright © 2017 Hatshit. All rights reserved.
//

import UIKit
import ObjectMapper

class CountryResponseBody: Mappable {

    var success: Bool?
    var message: String?
    var data:[CountryList]?
    var count: String?
    var total_count: String?

    
    required init?(map: Map) {
    
    }
    
    
    func mapping(map: Map) {
        success  <- map["success"]
        message  <- map["message"]
        data     <- map["data"]
        count     <- map["count"]
        total_count     <- map["total_count"]

    }
    
    
    
}
