//
//  ChatHomeDM.swift
//  Community
//
//  Created by Hatshit on 25/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit
import Firebase

class MYChatHomeDM: NSObject {
    
    var pext_date:String?
    var pst_completed:String?
    var pst_id:String?
    var pst_title:String?
    var scat_title:String?
    var pst_usr_id:String?
    
    var total_PostCount: Int?
    var chat_count:String?
    var chat_report:String?
     var pext_timeZone:String?
    

    var individualPostRef : DatabaseReference?
    var individualPostHandler : DatabaseHandle?
    
    var firMyChatUnread : DatabaseReference?
    var firMyChatUnreadHandler : DatabaseHandle?
    var chatNode : String?
    
    var callbackFromChatHomeDM: ((Bool) -> Void)?
    var usr_report : String?

    
    init(dic:[String:Any]){
         super.init()
        
        usr_report = dic["usr_report"] as? String
        chat_count = dic["chat_count"] as? String
        chat_report = dic["chat_report"] as? String
        pext_date = dic["pext_date"] as? String
        pst_completed = dic["pst_completed"] as? String
        pst_id = dic["pst_id"] as? String
        pst_title = dic["pst_title"] as? String
        scat_title = dic["scat_title"] as? String
        pst_usr_id = dic["pst_usr_id"] as? String
        pext_timeZone = dic["pext_timeZone"] as? String
        total_PostCount = dic["total_PostCount"] as? Int
        individualPostRef = dic["individualPostRef"] as? DatabaseReference
        individualPostHandler = dic["individualPostHandler"] as? DatabaseHandle
        callbackFromChatHomeDM = dic["callbackFromChatHomeDM"] as? ((Bool) -> Void)
        
        if(pst_usr_id == getUserData()["usr_id"] as? String){
            individualPostRef = Database.database().reference(withPath: String(format: "/PostUnReadCount/postUnread_%@/",pst_id!))
            
            
           // print(individualPostRef!)
            
            individualPostHandler = individualPostRef?.observe(.value, with: { [unowned self] (snapshot : DataSnapshot) in
                guard snapshot.exists() else{ return  }
                
                
                let snapValue = snapshot.value as? [String : Any]
                
               // print(snapValue ?? "")
                
                if(snapshot.value != nil){
                    
                   // print(self.pst_id! )
                   // print(snapshot)
                   // print(snapshot.key)
                    
                    if self.pst_id != nil {
                    //if(self.pst_id != nil && self.pst_id != ""){
                    let str = String(format: "postUnread_%@", self.pst_id!)
                    
                   // print(str )
                    
                    if(snapshot.key == str){
                        
                        //print(snapValue?["postunread"] as! Int)
                        self.total_PostCount = snapValue?["postunread"] as? Int
                        if self.callbackFromChatHomeDM != nil {
                            self.callbackFromChatHomeDM!(true)
                        }
                        
                    }
                  }
                }
            })
            
        }else {
            
            chatNode = String(format: "user-help-request-chat/%@_%@_%@",pst_usr_id!, getUserData()["usr_id"] as! String,pst_id!)
           
            firMyChatUnread = Database.database().reference(withPath: String(format: "/%@/status/user_id_%@/",chatNode!, pst_usr_id!))
            
           // print(firMyChatUnread!)
            
            firMyChatUnreadHandler = firMyChatUnread?.observe(.value, with: { [unowned self] (snapshot : DataSnapshot) in
                guard snapshot.exists() else{ return  }
                
                
                let snapValue = snapshot.value as? [String : Any]
                
                if(snapshot.value != nil){
                    let str = String(format: "user_id_%@", self.pst_usr_id!)
                    if(snapshot.key == str){
                        self.total_PostCount = snapValue?["unread"] as? Int
                        if self.callbackFromChatHomeDM != nil {
                            self.callbackFromChatHomeDM!(true)
                        }
                    }
                }
            })
        }
        
        
       
        
    }
    
    
    func removeObservernotyOfMyChatHomeDm () {
        individualPostRef?.removeObserver(withHandle: individualPostHandler!)
        firMyChatUnread?.removeObserver(withHandle: firMyChatUnreadHandler!)
    }
}
