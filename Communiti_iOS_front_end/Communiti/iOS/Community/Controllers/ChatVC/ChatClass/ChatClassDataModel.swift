    //
//  ChatClassDataModel.swift
//  Community
//
//  Created by Hatshit on 16/01/18.
//  Copyright © 2018 Hatshit. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications


class ChatClassDataModel: NSObject , UNUserNotificationCenterDelegate {
    
    var hlp_pst_id : String?
    var usr_fname : String?
    var otherUser_id : String?
    var pst_usr_id : String?

    
    
      var callBackForUnread: ((_ count : Int) -> Void)?
    
     var myUnreadCount = 0
     var myPostCount = 0
     var myOtherPostCount = 0
     var initiallyAdd = false
    
    //Chat Instance
    var chatNode : String?
    var firBaseMsgRefresh : DatabaseReference?
    var firNewMsgHandler : DatabaseHandle?
    
    var firMyChatUnread : DatabaseReference?
    var firMyChatUnreadHandler : DatabaseHandle?
    
    init(dic:[String:Any]){
        super.init()
        hlp_pst_id = dic["hlp_pst_id"] as? String
        usr_fname = dic["usr_fname"] as? String
        otherUser_id = dic["usr_id"] as? String
        pst_usr_id = dic["pst_usr_id"] as? String


        
        if(pst_usr_id == getUserData()["usr_id"] as? String){
            
            chatNode = String(format: "user-help-request-chat/%@_%@_%@", getUserData()["usr_id"] as! String,otherUser_id ?? "",hlp_pst_id!)
            
        }else{
            
            chatNode = String(format: "user-help-request-chat/%@_%@_%@",otherUser_id ?? "", getUserData()["usr_id"] as! String,hlp_pst_id!)
            
        }
        firBaseMsgRefresh = Database.database().reference(withPath:String(format: "/%@/message",chatNode!))
        
        self.initiallyAdd = true
        
       firNewMsgHandler = firBaseMsgRefresh?.queryOrderedByKey().queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot : DataSnapshot) in
        
        //print("call number of time %@",snapshot);

        if(snapshot.value != nil){
            if(!self.initiallyAdd){
           
                if((snapshot.value as! [String : Any])["sender"] as? String == self.otherUser_id){
                
                    if( APP_Delegate().currentChatUser != (snapshot.value as! [String : Any])["sender"] as? String){
           
                        if #available(iOS 10.0, *) {
   
                            let content = UNMutableNotificationContent()
                           // content.title = (snapshot.value as! [String : Any])["firstname"] as! String
                             content.title = String(format: "%@ %@", (snapshot.value as! [String : Any])["firstname"] as! String , (snapshot.value as! [String : Any])["lastname"] as! String)
                            
                            content.body = (snapshot.value as! [String : Any])["message"] as! String
                            content.sound = UNNotificationSound.default()
                            content.userInfo = ["aps":["type":"FIREBASE_CHAT_MSG","info":snapshot.value as! [String : Any]]]
                            
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                            let request = UNNotificationRequest(identifier: "Local_Chat_Notification", content: content, trigger: trigger)
                             let center = UNUserNotificationCenter.current()
                             center.add(request, withCompletionHandler: { (error) in
                                if error != nil {
                                    // Something went wrong
                                }
                            })
                        } else {
                            // Fallback on earlier versions
                            
                            let notification = UILocalNotification()
                            notification.fireDate = NSDate(timeIntervalSinceNow: 0) as Date
                            notification.alertBody = (snapshot.value as! [String : Any])["message"] as? String
                             notification.alertTitle = (snapshot.value as! [String : Any])["firstname"] as? String
                            notification.soundName =  UILocalNotificationDefaultSoundName
                            notification.timeZone = NSTimeZone.default
                            UIApplication.shared.scheduleLocalNotification(notification)
                            
                        }
                   //} /*else{
                        
                      //  print("Application in forground")
                  //  }*/
                }
              }
            }
          }
      })
        
        
        firBaseMsgRefresh?.queryOrderedByKey().queryLimited(toLast: 1).observeSingleEvent(of: .value, with: { (snapshot : DataSnapshot) in
            
            self.initiallyAdd = false
            //print("call one time");
        })
        
        
        //MARK:- -------my unread count (mess send by other user) ------
        
         firMyChatUnread = Database.database().reference(withPath: String(format: "/%@/status/user_id_%@/",chatNode!, otherUser_id ?? ""))
        
         //print(firMyChatUnread!)
        
         firMyChatUnreadHandler = firMyChatUnread?.observe(.value, with: { [unowned self] (snapshot : DataSnapshot) in
            guard snapshot.exists() else{ return  }
            
            
            let snapValue = snapshot.value as? [String : Any]

            //print("userid %@",self.otherUser_id!)
            
            if(snapshot.value != nil){
              if( self.otherUser_id != nil){
                let str = String(format: "user_id_%@", self.otherUser_id!)
               // if(snapshot.key == str){
                    self.myUnreadCount = snapValue?["unread"] as! Int
                    if((self.callBackForUnread) != nil){
                        self.callBackForUnread!(snapValue?["unread"] as! Int)
                   // }
                }
              }
            }
        })
    }
   
    func removeObservernotification()  {
        firBaseMsgRefresh?.removeObserver(withHandle: firNewMsgHandler!)
        firMyChatUnread?.removeObserver(withHandle: firMyChatUnreadHandler!)
    }
    
    
    func unreadMessageCallback(callBack : @escaping ((Int)) -> Void ) {
      if (callBackForUnread != nil) {
            callBackForUnread=nil;
        }
        
        callBackForUnread = callBack
        if (callBackForUnread != nil) {
            if(myUnreadCount > 0) {
                callBackForUnread!(myUnreadCount);
              }
         }
    }

    
}//END


