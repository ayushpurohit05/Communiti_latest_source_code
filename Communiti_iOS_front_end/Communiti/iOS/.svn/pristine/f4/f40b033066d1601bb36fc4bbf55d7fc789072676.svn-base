//
//  ChatMyAndOthrHelpReqDM.swift
//  Community
//
//  Created by Hatshit on 18/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit
import Firebase

class ChatMyAndOthrHelpReqDM: NSObject {
    
    var profile_image:String?
    var usr_fname:String?
    var usr_id:String?
    var chat_report : String?
    
    var userMess : String?
    var senderId : String?
    var isUnreadMess : Bool = false

    
    
    var chatNode : String?
    var firBaseMsgRefresh : DatabaseReference?
    var gerLastMessHandler : DatabaseHandle?
    
    var userUnreadCount : DatabaseReference?
    var userUnreadCountHandler : DatabaseHandle?
    
    var callbackFromChatIndiVidualDM: ((Bool) -> Void)?

    
    init(dic:[String:Any] ,pstCreater_Id : String , hlp_pst_id : String){
         super.init()
        
        profile_image = dic["profile_image"] as? String
        usr_fname = dic["usr_fname"] as? String
        usr_id = dic["usr_id"] as? String
        chat_report = dic["chat_report"] as? String
        if(pstCreater_Id == getUserData()["usr_id"] as! String){
            chatNode = String(format: "user-help-request-chat/%@_%@_%@", getUserData()["usr_id"] as! String,usr_id!,hlp_pst_id) //  userId means other user id
        }else{
            chatNode = String(format: "user-help-request-chat/%@_%@_%@",usr_id!, getUserData()["usr_id"] as! String,hlp_pst_id) //  userId means other user id
        }
        
        
        
        userUnreadCount = Database.database().reference(withPath: String(format: "/%@/status/user_id_%@/",chatNode!, usr_id! ))
        userUnreadCountHandler = userUnreadCount?.observe(.childChanged, with: { (snapshot : DataSnapshot) in
            guard snapshot.exists() else{ return  }
            if(snapshot.key == "unread"){
                //self.userUnreadCount = snapshot.value as! Int
            }
        })
        
        userUnreadCount?.observeSingleEvent(of: .value, with: { (snapshot : DataSnapshot) in
            guard snapshot.exists() else{ return  }
            let snapValue = snapshot.value as? [String : Any]
            
            if(snapValue?["unread"] != nil){
                let urreadCount = snapValue?["unread"]as! Int
                if(urreadCount > 0){
                    self.isUnreadMess = true
                }else{
                    self.isUnreadMess = false
                }
                
                
            }
        })
        

        firBaseMsgRefresh = Database.database().reference(withPath:String(format: "/%@/message",chatNode!))
        
        //MARK:- -------add mess By Me ------
        gerLastMessHandler = firBaseMsgRefresh?.queryOrderedByKey().queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot : DataSnapshot) in
            
            if(snapshot.value != nil){
                
                let dictOfData =  snapshot.value as! [String : Any]
                self.userMess = dictOfData["message"] as? String
                self.senderId = dictOfData["sender"] as? String

                if self.callbackFromChatIndiVidualDM != nil {
                    self.callbackFromChatIndiVidualDM!(true)
                }

            }
        })
        
        
     
        
    }
    
    func removeObservernotyOfChatIndividualPostDM () {
        firBaseMsgRefresh?.removeObserver(withHandle: gerLastMessHandler!)
        
    }

}
