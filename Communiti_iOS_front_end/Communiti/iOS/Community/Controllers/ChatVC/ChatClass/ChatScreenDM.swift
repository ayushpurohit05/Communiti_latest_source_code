//
//  ChatScreenDM.swift
//  Community
//
//  Created by Hatshit on 22/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit
import Firebase

class ChatScreenDM: NSObject {
    
    var snapShotKey : String?
    var firstname:String?
    var lastname:String?
    var message:String?
    var receipt:String?
    var sender:String?
    var timestamp:String?
    
    
    init( snapshot : DataSnapshot){
        let dict = snapshot.value as! [String : Any]
        snapShotKey = snapshot.key as? String
        firstname = dict["firstname"] as? String
        lastname = dict["lastname"] as? String
        message = dict["message"] as? String
        receipt = dict["receipt"] as? String
        sender = dict["sender"] as? String
        timestamp = dict["timestamp"] as? String
    }

}
