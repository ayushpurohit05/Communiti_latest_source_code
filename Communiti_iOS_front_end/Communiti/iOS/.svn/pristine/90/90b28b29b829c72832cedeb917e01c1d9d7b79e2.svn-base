//
//  ChatHomeDataModel.swift
//  Community
//
//  Created by Hatshit on 15/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit
import ObjectMapper

import Firebase

class ChatHomeDataModel: NSObject, Mappable {
    
    
    var chat_count:String?
    var pext_date:String?
    var pst_completed:String?
    var pst_id:String?
    var pst_title:String?
    var scat_title:String?
    var pst_usr_id:String?
    var total_PostCount: Int?
    
    var firMyChatUnread : DatabaseReference?
    var firMyChatUnreadHandler : DatabaseHandle?
    
    var callbackFromChatHomeDM: ((Bool) -> Void)?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        chat_count <- map["chat_count"]
        pext_date <- map["pext_date"]
        pst_completed   <- map["pst_completed"]
        pst_id  <- map["pst_id"]
        pst_title     <- map["pst_title"]
        scat_title  <- map["scat_title"]
        pst_usr_id  <- map["pst_usr_id"]
        total_PostCount  <- map["total_PostCount"]
        
        callbackFromChatHomeDM  <- map["callbackFromChatHomeDM"]



        
        
        firMyChatUnread = Database.database().reference(withPath: String(format: "/PostUnReadCount/postUnread_%@/",pst_id!))
        
        
        //print(firMyChatUnread!)
        
        firMyChatUnreadHandler = firMyChatUnread?.observe(.value, with: { [unowned self] (snapshot : DataSnapshot) in
            guard snapshot.exists() else{ return  }
            
            
            let snapValue = snapshot.value as? [String : Any]
            
            //print(snapValue ?? "")
            
            if(snapshot.value != nil){
                
                let str = String(format: "postUnread_%@", self.pst_id!)
                
                 //print(str )
                
                if(snapshot.key == str){
                  
                    //print(snapValue?["postunread"] as! Int)
                    self.total_PostCount = snapValue?["postunread"] as? Int
                    
                    
                    if self.callbackFromChatHomeDM != nil {
                        self.callbackFromChatHomeDM!(true)
                    }
                    
                    
                    
                    
                    // if((self.callBackForUnread) != nil){
                        //self.callBackForUnread!(snapValue?["unread"] as! Int)
                    //}
                }
            }
        })
        
    }
    
        
   


}
